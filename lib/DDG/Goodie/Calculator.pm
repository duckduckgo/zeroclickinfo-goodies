package DDG::Goodie::Calculator;
# ABSTRACT: Handles the triggering and query preprocessing for the calculator

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

use utf8;

zci answer_type => 'calc';
zci is_cached   => 1;

my $calc_regex = qr/^(free)?(online)?calc(ulator)?(online)?(free)?$/i;
triggers query_nowhitespace => $calc_regex;

triggers query_nowhitespace => qr'^
    (?: [0-9 () τ π e √ x × ∙ ⋅ * + \- ÷ / \^ \$ £ € \. \, _ ! = ]+ |
    \d+\%=?$ |
    what is| calculat(e|or) | solve | math |
    times | divided by | plus | minus | cos | tau |
    sin | tan | cotan | log | ln | exp | tanh |
    sec | csc | squared | sqrt | gross | dozen | pi |
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
    'minus'       => '-',
    'plus'        => '+',
    'divided\sby' => '/',
    '÷'           => '/',
    'squared'     => '**2',
);

my %named_constants = (
    dozen => 12,
    gross => 144,
    score => 20,
);

my $ored_constants = join('|', keys %named_constants);                      # For later substitutions

my $ip4_octet = qr/([01]?\d\d?|2[0-4]\d|25[0-5])/;                          # Each octet should look like a number between 0 and 255.
my $ip4_regex = qr/(?:$ip4_octet\.){3}$ip4_octet/;                          # There should be 4 of them separated by 3 dots.
my $up_to_32  = qr/([1-2]?[0-9]{1}|3[1-2])/;                                # 0-32
my $network   = qr#^$ip4_regex\s*/\s*(?:$up_to_32|$ip4_regex)\s*$#;         # Looks like network notation, either CIDR or subnet mask

## prepares the query to interpreted by the calculator front-end
sub prepare_for_frontend {
    my ($query, $style) = @_;

    # Equals varies by output type.
    $query =~ s/\=$//;
    $query =~ s/(\d)[ _](\d)/$1$2/g;    # Squeeze out spaces and underscores.
    # Show them how 'E' was interpreted. This should use the number styler, too.
    $query =~ s/([\d\.\-]+)E([\-\d\.]+)/\($1 * 10^$2\)/ig;
    $query =~ s/\s*\*\*\s*/^/g;    # Use prettier exponentiation.
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
    $text =~ s/\s{2,}/ /g;

    return $text;
}

# rewrites the users original query to include operator
# rewriteQuery '2 plus 2'   -> '2 + 2'
sub rewriteQuery {
    my ($text) = @_;

    $text =~ s/plus/+/g;
    $text =~ s/minus/-/g;
    $text =~ s/times/×/g;
    $text =~ s/divided\s?by/÷/g;
    $text =~ s/(cos|tau|τ|sin|tan|cotan|log|ln|exp|tanh|π|sec|csc|squared|sqrt|gross|dozen|pi|e|score)\s*\1/$1/g;
    $text =~ s|([x × ∙ ⋅ % + \- ÷ / \^ \$ £ € \. \, _ =])\s*\1|$1|gx;

    return $text;
}

handle query_nowhitespace => sub {
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

    return unless $query =~ m/[0-9τπe]|tau|pi/;
    return if $req->query_lc =~ /^0x/i; # hex maybe?
    return if $query =~ $network;    # Probably want to talk about addresses, not calculations.
    return if $query =~ m/^(\+?\d{1,2}(\s|-)?|\(\d{2})?\(?\d{3,4}\)?(\s|-)?\d{3}(\s|-)?\d{3,4}(\s?x\d+)?$/; # Probably are searching for a phone number, not making a calculation
    return if $query =~ m{[x × ∙ ⋅ * % + \- ÷ / \^ \$ £ € \. ,]{3,}}ix;
    return if $query =~ m/\$[^\d\.]/;
    return if $query =~ m/\(\)/;
    return if $query =~ m{//};
    return if $query =~ m/(^|[^\d])!/g;
    return if $query =~ m/0x[A-Za-z]{2,}/;
    return if $query =~ m/=(.+)/;

    $query =~ s/^(?:whatis|calculat(e|or)|solve|math)//i;

    return if $query =~ /^(?:minus|-|\+)\d+$/;

    # Grab expression.
    my $tmp_expr = spacing($query, 1);
    return if ($tmp_expr eq $query) && ($query !~ /\de|ln|log|cos|tan|sin/i);     # If it didn't get spaced out, there are no operations to be done.

    # First replace named operations with their computable equivalents.
    while (my ($name, $operation) = each %named_operations) {
        $query =~ s#$name#$operation#xig;    # We want these ones to show later.
    }

    # Now sub in constants
    while (my ($name, $constant) = each %named_constants) {
        $query =~ s#\b$name\b#($name)#ig;
    }
    my @numbers = grep { $_ =~ /^$number_re$/ } (split /\s+/, $tmp_expr);
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
