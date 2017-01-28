package DDG::Goodie::Calculator;
# ABSTRACT: do simple arthimetical calculations

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

use List::Util 'max';
use Math::Trig;
use Math::BigInt;
use Safe;

use utf8;

zci answer_type => 'calc';
zci is_cached   => 1;

triggers query_nowhitespace => qr'
    (?: [0-9] |
    times | divided by | plus | minus | fact | factorial | cos |
    sin | tan | cotan | log | ln | log_?\d{1,3} | exp | tanh |
    sec | csc | squared | sqrt | gross | dozen | pi |
    | score){3,}
'xi;

my $number_re = number_style_regex();
my $funcy     = qr/[[a-z]+\(|log[_]?\d{1,3}\(|\^|\*|\/|squared|divided/;    # Stuff that looks like functions.

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
    'ln'          => 'log',                                                 # perl log() is natural log.
    'squared'     => '**2',
    'fact'        => 'Math::BigInt->new',
);

my %named_constants = (
    dozen => 12,
    e     => 2.71828182845904523536028747135266249,                         # This should be computed.
    pi    => pi,                                                            # pi constant from Math::Trig
    gross => 144,
    score => 20,
);

my $ored_constants = join('|', keys %named_constants);                      # For later substitutions

my $ip4_octet = qr/([01]?\d\d?|2[0-4]\d|25[0-5])/;                          # Each octet should look like a number between 0 and 255.
my $ip4_regex = qr/(?:$ip4_octet\.){3}$ip4_octet/;                          # There should be 4 of them separated by 3 dots.
my $up_to_32  = qr/([1-2]?[0-9]{1}|3[1-2])/;                                # 0-32
my $network   = qr#^$ip4_regex\s*/\s*(?:$up_to_32|$ip4_regex)\s*$#;         # Looks like network notation, either CIDR or subnet mask

my $safe = new Safe;
$safe->permit_only(qw'
    :base_core :base_math
    rv2gv require caller padany
');

$safe->deny(qw'warn die');

$safe->share_from('Math::Trig', [qw'csc sec tanh tan cotan']);
$safe->share_from('main', [qw'
    Math::BigInt::modify
    Math::BigInt::bzero
    Math::BigInt::bfac
    Math::BigInt::bstr
    Math::BigInt::new
    Math::BigInt::round
    Math::BigInt::Calc::_new
    Math::BigInt::Calc::_str
    Math::BigInt::Calc::_zero
    Math::BigInt::Calc::_fac
']);

handle query_nowhitespace => sub {
    my $query = $_;

    return if ($query =~ /\b0x/);      # Probably attempt to express a hexadecimal number, query_nowhitespace makes this overreach a bit.
    return if ($query =~ $network);    # Probably want to talk about addresses, not calculations.
    return if ($query =~ qr/(?:(?<pcnt>\d+)%(?<op>(\+|\-|\*|\/))(?<num>\d+)) | (?:(?<num>\d+)(?<op>(\+|\-|\*|\/))(?<pcnt>\d+)%)/);    # Probably want to calculate a percent ( will be used PercentOf )
    return if ($query =~ /^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$/); # Probably are searching for a phone number, not making a calculation
    return if $query =~ /[":]/;
    return if $query =~ m{[x X × ∙ ⋅ * % + \- ÷ / \^ \$ \. ,]{3,}};
    return if $query =~ /\@/;
    return if $query =~ /\$[^\d\.]/;
    return if $query =~ /\(\)/;

    $query =~ s/^(?:whatis|calculate|solve|math)//;
    $query =~ s/factorial/fact/;     #replace factorial with fact

    # Grab expression.
    my $tmp_expr = spacing($query, 1);

    return if $tmp_expr eq $query;     # If it didn't get spaced out, there are no operations to be done.

    # First replace named operations with their computable equivalents.
    while (my ($name, $operation) = each %named_operations) {
        $tmp_expr =~ s# $name # $operation #xig;
        $query =~ s#$name#$operation#xig;    # We want these ones to show later.
    }

    $tmp_expr =~ s#log[_]?(\d{1,3})#(1/log($1))*log#xg;                # Arbitrary base logs.
    $tmp_expr =~ s/ (\d+?)E(-?\d+)([^\d]|\b) /\($1 * 10**$2\)$3/ixg;   # E == *10^n
    $tmp_expr =~ s/\$//g;                                              # Remove $s.
    $tmp_expr =~ s/=$//;                                               # Drop =.
    $tmp_expr =~ s/([0-9])\s*([a-zA-Z])([^0-9])/$1*$2$3/g;             # Support 0.5e or 0.5pi; but don't break 1e8
    # Now sub in constants
    while (my ($name, $constant) = each %named_constants) {
        $tmp_expr =~ s# (\d+?)\s+$name # $1 * $constant #xig;
        $tmp_expr =~ s#\b$name\b# $constant #ig;
        $query =~ s#\b$name\b#($name)#ig;
    }

    my @numbers = grep { $_ =~ /^$number_re$/ } (split /\s+/, $tmp_expr);
    my $style = number_style_for(@numbers);
    return unless $style;

    $tmp_expr = $style->for_computation($tmp_expr);
    $tmp_expr =~ s/Math::BigInt->new\(([^)]+)\)/Math::BigInt->new\($1\)->bfac->bstr/g;    #correct expression for fact
    # Using functions makes us want answers with more precision than our inputs indicate.
    my $precision = ($query =~ $funcy) ? undef : ($query =~ /^\$/) ? 2 : max(map { $style->precision_of($_) } @numbers);
    my $tmp_result;
    # e.g. sin(100000)/100000 completely makes this go haywire.
    {
        # we don't care about reval's warnings
        local $SIG{__WARN__} = sub {};
        $tmp_result = $safe->reval($tmp_expr, 'STRICT');
    }
    # if you want to see why $tmp_expr wasn't evaluated, uncomment the following
    # warn "reval failed: $@";

    # Guard against non-result results
    return unless (defined $tmp_result && $tmp_result ne 'inf' && $tmp_result ne '');
    # Try to determine if the result is supposed to be 0, but isn't because of FP issues.
    # If there's a defined precision, let sprintf worry about it.
    # Otherwise, we'll say that smaller than 1e-14 was supposed to be zero.
    # -14 selected to account for the result of sin(pi)
    $tmp_result = 0 if (not defined $precision and ($tmp_result =~ /e\-(?<exp>\d+)$/ and $+{exp} > 14));
    $tmp_result = sprintf('%0.' . $precision . 'f', $tmp_result) if ($precision);
    # Dollars.
    $tmp_result = '$' . $tmp_result if ($query =~ /^\$/);

    my $results = prepare_for_display($query, $tmp_result, $style);

    return if $results->{text} =~ /^\s/;
    return $results->{text},
      structured_answer => $results->{structured},
      heading           => "Calculator";
};

sub prepare_for_display {
    my ($query, $result, $style) = @_;

    # Equals varies by output type.
    $query =~ s/\=$//;
    $query =~ s/(\d)[ _](\d)/$1$2/g;    # Squeeze out spaces and underscores.
    # Show them how 'E' was interpreted. This should use the number styler, too.
    $query =~ s/((?:\d+?|\s))E(-?\d+)/\($1 * 10^$2\)/i;
    $query =~ s/\s*\*\*\s*/^/g;    # Use prettier exponentiation.
    $query =~ s/Math::BigInt->new\(([^)]+)\)/fact\($1\)/g;    #replace Math::BigInt->new( with fact(
    $result = $style->for_display($result);
    foreach my $name (keys %named_constants) {
        $query =~ s#\($name\)#$name#xig;
    }

    my $spaced_query = spacing($query);
    return +{
        text       => $spaced_query . ' = ' . $result,
        structured => {
            input     => [$spaced_query],
            operation => 'Calculate',
            result => "<a href='javascript:;' onclick='document.x.q.value=\"$result\";document.x.q.focus();'>" . $style->with_html($result) . "</a>"
        },
    };
}

#separates symbols with a space
#spacing '1+1'  ->  '1 + 1'
sub spacing {
    my ($text, $space_for_parse) = @_;

    $text =~ s/\s{2,}/ /g;
    $text =~ s/(\s*(?<!<)(?:[\+\^xX×∙⋅\*\/÷\%]|(?<!\de)\-|times|plus|minus|dividedby)+\s*)/ $1 /ig;
    $text =~ s/\s*dividedby\s*/ divided by /ig;
    $text =~ s/(\d+?)((?:dozen|pi|gross|squared|score))/$1 $2/ig;
    $text =~ s/([\(\)])/ $1 /g if $space_for_parse;

    return $text;
}

1;
