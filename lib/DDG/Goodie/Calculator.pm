package DDG::Goodie::Calculator;
# ABSTRACT: Handles the triggering and query preprocessing for the calculator

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

use utf8;

zci answer_type => 'calc';
zci is_cached   => 1;

my $calc_regex = qr/^(free)?\s?(online)?\s?calc(ulator)?\s?(online)?\s?(free)?$/i;
triggers query => $calc_regex;

triggers query => qr'^
    (?: [0-9 () τ π e √ x × ∙ ⋅ * + \- ÷ / \^ \$ £ € \. \, _ ! = % ]+ |
    \d+\%=?$ |
    what\sis| calculat(e|or) | solve | math | log\sof |
    times | mult | multiply | divided\sby | plus | minus | cos | tau |
    sin | tan | cotan | log | ln | exp | tanh |
    sec | csc | squared | sqrt | \d+\s?mod(?:ulo)?\s?\d+ | gross | dozen | pi |
    score){2,}$
'xi;

my $number_re = number_style_regex();

my %named_operations = (
    '\^'          => '**',
    'x'           => '*',
    '×'           => '*',
    '∙'           => '*',
    '⋅'           => '*',                                                   # Can be mistaken for dot operator
    'times'       => '*',
    'mult'        => '*',
    'multiply'    => '*',
    'minus'       => '-',
    'plus'        => '+',
    'divided\sby' => '/',
    '÷'           => '/',
    'mod'         => 'mod',
    'modulo'      => 'modulo',
    'squared'     => '**2',
);

my %named_constants = (
    dozen => 12,
    gross => 144,
    score => 20,
);

my $ored_constants = join('|', keys %named_constants);                      # For later substitutions

# operators that are allowed and not allowed at start/end of expression
my $no_start_ops = qr{^(?:x|×|∙|⋅|\*|÷|/|\^|\,|_)};
my $no_end_ops = qr{(?:√|x|×|∙|⋅|\*|\+|\-|÷|/|\^|\$|£|€|\,|_)$};
my $word_ops = join "|", ("dividedby", "divided by", "times", "plus", "minus");
my $no_word_ops = qr{(^(?:$word_ops)|(?:$word_ops)$)};                          # word based operators at start / end

my $ip4_octet = qr/([01]?\d\d?|2[0-4]\d|25[0-5])/;                          # Each octet should look like a number between 0 and 255.
my $ip4_regex = qr/(?:$ip4_octet\.){3}$ip4_octet/;                          # There should be 4 of them separated by 3 dots.
my $up_to_32  = qr/([1-2]?[0-9]{1}|3[1-2])/;                                # 0-32
my $network   = qr#^$ip4_regex\s*/\s*(?:$up_to_32|$ip4_regex)\s*$#;         # Looks like network notation, either CIDR or subnet mask

## prepares the query to interpreted by the calculator front-end
sub prepare_for_frontend {
    my ($query, $style) = @_;

    # Equals varies by output type.
    $query =~ s/\=$//;
    $query =~ s/(\d)[ _](\d)/$1$2/g;     # Squeeze out spaces and underscores.
    # Show them how 'E' was interpreted. This should use the number styler, too.
    $query =~ s/([\d\.\-]+)E([\-\d\.]+)/\($1 * 10^$2\)/ig;
    $query =~ s/\s*\*\*\s*/^/g;    # Use prettier exponentiation.

    $query = $style->for_computation($query);  # Make sure period is used as decimal point
    foreach my $name (keys %named_constants) {
        $query =~ s#\($name\)#$name#xig;
    }

    my $spaced_query = rewriteQuery(spacing($query));
    $spaced_query =~ s/^ - /-/;

    return $spaced_query;
}

# separates symbols with a space
# spacing '1+1'  ->  '1 + 1'
sub spacing {
    my ($text, $space_for_parse) = @_;

    $text =~ s/\s{2,}/ /g;
    $text =~ s/(\s*(?<!<)(?:[\+\^xX×∙⋅\*\/÷]|(?<!\de)\-|times|plus|minus|divided\s*by)+\s*)/ $1 /ig;
    $text =~ s/\s*dividedby\s*/ divided by /ig;
    $text =~ s/(\d+?)((?:dozen|pi|gross|squared|score))/$1 $2/ig;
    $text =~ s/([\(\)])/ $1 /g if $space_for_parse;
    $text =~ s/\|/,/g;
    $text =~ s/\s{2,}/ /g;

    return $text;
}

# rewrites the users original query to include operator
# rewriteQuery '2 plus 2'   -> '2 + 2'
sub rewriteQuery {
    my ($text) = @_;

    $text =~ s/plus/+/g;
    $text =~ s/minus/-/g;
    $text =~ s/times|mult/×/g;
    $text =~ s/divided\s?by/÷/g;
    $text =~ s/(cos|tau|τ|sin|tan|cotan|log|ln|exp|tanh|π|sec|csc|squared|sqrt|gross|dozen|pi|e|score)\s*\1/$1/g;
    $text =~ s|([x × ∙ ⋅ % + \- ÷ / \^ \$ £ € \. \, _ =])\s*\1|$1|gx;

    return $text;
}

# rewrites log/ln functions coming from the search bar
# log of 5 --> log(5), log2 8 --> log(8,2), log321 --> log(321)
sub rewriteFunctions {
    my ($query) = @_;

    # Preprocesses Log/Ln
    $query =~ s/log\sof\s(\d+)/log($1)/i;
    $query =~ s/log10\((\d+)\)/log($1)/i;
    $query =~ s/log10\s(\d+)/log($1)/i;
    $query =~ s/log(\d+)\s?\((.+)\)/log($2|$1)/i;
    $query =~ s/log(\d+)\s(\d+)/log($2|$1)/i;
    $query =~ s/log\s?(\d+)/log($1)/i;
    $query =~ s/ln\s?(\d+)/ln($1)/i;

    return $query;
}

handle query => sub {
    my $query = $_;

    if ($query =~ $calc_regex) {
        return '', structured_answer => {
            data => {
                query => undef
            },
            templates => {
                group => 'base',
                options => {
                    content => 'DDH.calculator.content'
                }
            }
        };
    }

    # We need to rewrite the functions for front-end consumption
    $query = rewriteFunctions($query);

    # throw out obvious non-calculations immediately
    return if $query =~ qr/(\$(.+)?(?=£|€))|(£(.+)?(?=\$|€))|(€(.+)?(?=\$|£))/; # only let one currency type through
    return if $req->query_lc =~ /^0x/i; # hex maybe?
    return if $query =~ $network;    # Probably want to talk about addresses, not calculations.
    return if $query =~ m/^(\+?\d{1,2}(\s|-)?|\(\d{2})?\(?\d{3,4}\)?(\s|-)?\d{3}(\s|-)?\d{3,4}(\s?x\d+)?$/; # Probably are searching for a phone number, not making a calculation
    return if $query =~ m/(\d+)\s+(\d+)/; # if spaces between numbers then bail

    # some shallow preprocessing of the query
    $query =~ s/(\d+)\s+%\s?(\d+)/$1mod$2/;
    $query =~ s/^(?:what is|calculat(e|or)|solve|math)//i; 
    $query =~ s/\s//g;

    # return based on the query type
    return unless $query =~ m/[0-9τπe]|tau|pi/;
    return if $query =~ $no_start_ops; # don't trigger with illegal operator at start
    return if $query =~ $no_end_ops; # don't trigger with illegal operator at end
    return if $query =~ $no_word_ops;
    return if $query =~ m{[x × ∙ ⋅ * + \- ÷ / \^ \$ £ € \. ,]{3,}}ix;
    return if $query =~ m/\$[^\d\.]/;
    return if $query =~ m/\(\)/;
    return if $query =~ m{//};
    return if $query =~ m/(^|[^\d])!/g;
    return if $query =~ m/0x[A-Za-z]{2,}/;
    return if $query =~ m/X\d+/;
    return if $query =~ m/9\/11/; # date edge case
    return if $query =~ m/.+=.+/; # check there isn't something on both sides of the equals sign
    return if $query =~ /^(?:minus|-|\+)\d+$/;

    # Grab expression.
    my $tmp_expr = spacing($query, 1);

    # First replace named operations with their computable equivalents.
    while (my ($name, $operation) = each %named_operations) {
        $query =~ s#$name#$operation#xig;    # We want these ones to show later.
    }

    return if ($tmp_expr eq $query) && ($query !~ /\de|cos|tan|sin|log|ln|mod|modulo/i);     # If it didn't get spaced out, there are no operations to be done.

    # Now sub in constants
    while (my ($name, $constant) = each %named_constants) {
        $query =~ s#\b$name\b#($name)#ig;
    }
    my @numbers = $tmp_expr =~ m/$number_re/g; 
    my $style = number_style_for(@numbers);
    return unless $style;

    my $spaced_query = prepare_for_frontend($query, $style);

    return '', structured_answer => {
        data => {
            query => $spaced_query
        },
        templates => {
            group => 'base',
            options => {
                content => 'DDH.calculator.content'
            }
        }
    };

};

1;
