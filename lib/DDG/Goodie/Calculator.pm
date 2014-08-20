package DDG::Goodie::Calculator;
# ABSTRACT: do simple arthimetical calculations

use feature 'state';

use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

use List::Util qw( max );
use Math::Trig;

zci is_cached   => 1;
zci answer_type => "calc";

primary_example_queries '$3.43+$34.45';
secondary_example_queries '64*343';
description 'Basic calculations';
name 'Calculator';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Calculator.pm';
category 'calculations';
topics 'math';
attribution
  web     => ['https://www.duckduckgo.com',    'DuckDuckGo'],
  github  => ['https://github.com/duckduckgo', 'duckduckgo'],
  twitter => ['http://twitter.com/duckduckgo', 'duckduckgo'];

triggers query_nowhitespace => qr<
        ^
       ( what is | calculate | solve | math )?

        [\( \) x X * % + / \^ \$ -]*

        (?: [0-9 \. ,]* )
        (?: gross | dozen | pi | e | c | squared | score |)
        [\( \) x X * % + / \^ 0-9 \. , \$ -]*

        (?(1) (?: -? [0-9 \. ,]+ |) |)
        (?: [\( \) x X * % + / \^ \$ -] | times | divided by | plus | minus | cos | sin | tan | cotan | log | ln | log[_]?\d{1,3} | exp | tanh | sec | csc | squared )+

        (?: [0-9 \. ,]* )
        (?: gross | dozen | pi | e | c | squared | score |)

        [\( \) x X * % + / \^ 0-9 \. , \$ -]* =? 

        $
        >xi;

my $number_re = number_style_regex();
my $funcy     = qr/[[a-z]+\(|log[_]?\d{1,3}\(|\^|\*|\//;    # Stuff that looks like functions.

my %named_operations = (
    '\^'          => '**',
    'x'           => '*',
    'times'       => '*',
    'minus'       => '-',
    'plus'        => '+',
    'divided\sby' => '/',
    'ln'          => 'log',                                 # perl log() is natural log.
    'squared'     => '**2',
);

my %named_constants = (
    dozen => 12,
    e     => 2.71828182845904523536028747135266249,         # This should be computed.
    pi    => pi,                                            # pi constant from Math::Trig
    gross => 144,
    score => 20,
);

my $ored_constants = join('|', keys %named_constants);      # For later substitutions

my $ip4_octet = qr/([01]?\d\d?|2[0-4]\d|25[0-5])/;                     # Each octet should look like a number between 0 and 255.
my $ip4_regex = qr/(?:$ip4_octet\.){3}$ip4_octet/;                     # There should be 4 of them separated by 3 dots.
my $up_to_32  = qr/([1-2]?[0-9]{1}|3[1-2])/;                           # 0-32
my $network   = qr#^$ip4_regex\s*/\s*(?:$up_to_32|$ip4_regex)\s*$#;    # Looks like network notation, either CIDR or subnet mask

handle query_nowhitespace => sub {
    my $results_html;
    my $results_no_html;
    my $query = $_;

    return if ($query =~ /\b0x/);      # Probable attempt to express a hexadecimal number, query_nowhitespace makes this overreach a bit.
    return if ($query =~ $network);    # Probably want to talk about addresses, not calculations.

    $query =~ s/^(?:whatis|calculate|solve|math)//;

    if ($query !~ /[xX]\s*[\*\%\+\-\/\^]/ && $query !~ /^-?[\d]{2,3}\.\d+,\s?-?[\d]{2,3}\.\d+$/) {

        # Grab expression.
        my $tmp_expr = spacing($query, 1);

        # First replace named operations with their computable equivalents.
        while (my ($name, $operation) = each %named_operations) {
            $tmp_expr =~ s# $name # $operation #xig;
        }

        $tmp_expr =~ s#log[_]?(\d{1,3})#(1/log($1))*log#xg;                # Arbitrary base logs.
        $tmp_expr =~ s/ (\d+?)E(-?\d+)([^\d]|\b) /\($1 * 10**$2\)$3/xg;    # E == *10^n
        $tmp_expr =~ s/\$//g;                                              # Remove $s.
        $tmp_expr =~ s/=$//;                                               # Drop =.

        # Now sub in constants
        while (my ($name, $constant) = each %named_constants) {
            $tmp_expr =~ s# (\d+?)\s+$name # $1 * $constant #xig;
            $tmp_expr =~ s#\b$name\b# $constant #ig;
        }

        my @numbers = grep { $_ =~ /^$number_re$/ } (split /\s+/, $tmp_expr);
        my $style = number_style_for(@numbers);
        return unless $style;

        $tmp_expr = $style->for_computation($tmp_expr);
        # Using functions makes us want answers with more precision than our inputs indicate.
        my $precision = ($query =~ $funcy) ? undef : max(map { $style->precision_of($_) } @numbers);

        my $tmp_result;
        eval {
            # e.g. sin(100000)/100000 completely makes this go haywire.
            alarm(1);
            $tmp_result = eval($tmp_expr);
            alarm(0);    # Assume the string processing will be "fast enough"
        };

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
          html    => $results->{html},
          heading => "Calculator";
    }

    return;
};

sub prepare_for_display {
    my ($query, $result, $style) = @_;

    # Equals varies by output type.
    $query =~ s/\=$//;
    # Show them how 'E' was interpreted. This should use the number styler, too.
    $query =~ s/((?:\d+?|\s))E(-?\d+)/\($1 * 10^$2\)/i;

    return {
        text => format_text($query, $result, $style),
        html => format_html($query, $result, $style),
    };
}

# Format query for HTML
sub format_html {
    my ($query, $result, $style) = @_;

    state $css = '<style type="text/css">' . share("style.css")->slurp . '</style>';

    $query  = $style->with_html($query);
    $result = $style->with_html($result);

    return
        $css
      . "<div class='zci--calculator text--primary'>"
      . spacing($query)
      . "<span class='text--secondary'> = </span><a href='javascript:;' onclick='document.x.q.value=\"$result\";document.x.q.focus();' class='text--primary'>"
      . $result
      . "</a></div>";
}

# Format query for text
sub format_text {
    my ($query, $result, $style) = @_;

    return spacing($query) . ' = ' . $style->for_display($result);
}

#separates symbols with a space
#spacing '1+1'  ->  '1 + 1'
sub spacing {
    my ($text, $space_for_parse) = @_;

    $text =~ s/(\s*(?<!<)(?:[\+\-\^xX\*\/\%]|times|plus|minus|dividedby)+\s*)/ $1 /ig;
    $text =~ s/\s*dividedby\s*/ divided by /ig;
    $text =~ s/(\d+?)((?:dozen|pi|gross|squared|score))/$1 $2/ig;
    $text =~ s/([\(\)\$])/ $1 /g if ($space_for_parse);

    return $text;
}

1;
