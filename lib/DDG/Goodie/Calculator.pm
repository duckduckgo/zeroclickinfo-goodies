package DDG::Goodie::Calculator;
# ABSTRACT: do simple arthimetical calculations

use DDG::Goodie;

use List::Util qw( all first max );
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
       ( what is | calculate | solve | math )? !?

        [\( \) x X * % + / \^ \$ -]*

        (?: [0-9 \. ,]* )
        (?: gross | dozen | pi | e | c |)
        [\( \) x X * % + / \^ 0-9 \. , \$ -]*

        (?(1) (?: -? [0-9 \. ,]+ |) |)
        (?: [\( \) x X * % + / \^ \$ -] | times | divided by | plus | minus | cos | sin | tan | cotan | log | ln | log[_]?\d{1,3} | exp | tanh | sec | csc)+

        (?: [0-9 \. ,]* )
        (?: gross | dozen | pi | e | c |)

        [\( \) x X * % + / \^ 0-9 \. , \$ -]* =? 

        $
        >xi;

# This is probably YAGNI territory, but since I have to reference it in two places
# and there are a multitude of other notation systems (although some break the
# 'thousands' assumption) I am going to pretend that I do need it.
#  If it could fit more than one the first in order gets preference.
my @known_styles = ({
        id            => 'perl',
        decimal       => '\.',
        sub_decimal   => '.',
        thousands     => ',',
        sub_thousands => ',',
    },
    {
        id            => 'euro',
        decimal       => ',',
        sub_decimal   => ',',
        thousands     => '\.',
        sub_thousands => '.',
    },
);

my $perl_style = first { $_->{id} eq 'perl' } @known_styles;
foreach my $style (@known_styles) {
    $style->{fit_check}   = _well_formed_for_style_func($style);
    $style->{precision}   = _precision_for_style_func($style);
    $style->{make_safe}   = _prepare_for_computation_func($style, $perl_style);
    $style->{make_pretty} = _display_style_func($style, $perl_style);
}

# This is not as good an idea as I might think.
# Luckily it will someday be able to be tokenized so this won't apply.
my $all_seps = join('', map { $_->{decimal} . $_->{thousands} } @known_styles);

my $numbery = qr/^[\d$all_seps]+$/;
my $funcy   = qr/[[a-z]+\(|log[_]?\d{1,3}\(|\^/;    # Stuff that looks like functions.

my %named_operations = (
    '\^'          => '**',
    'x'           => '*',
    'times'       => '*',
    'minus'       => '-',
    'plus'        => '+',
    'divided\sby' => '/',
    'ln'          => 'log',                         # perl log() is natural log.
);

my %named_constants = (
    dozen => 12,
    e     => 2.71828182845904523536028747135266249,    # This should be computed.
    pi    => pi,                                       # pi constant from Math::Trig
    gross => 144,
);

my $ored_constants = join('|', keys %named_constants);    # For later substitutions

handle query_nowhitespace => sub {
    my $results_html;
    my $results_no_html;
    my $query = $_;

    $query =~ s/^(?:whatis|calculate|solve|math)//;

    if ($query !~ /[xX]\s*[\*\%\+\-\/\^]/ && $query !~ /^-?[\d]{2,3}\.\d+,\s?-?[\d]{2,3}\.\d+$/) {
        my $tmp_result = '';

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

        my @numbers = grep { $_ =~ $numbery } (split /\s+/, $tmp_expr);
        my $style = display_style(@numbers);
        return unless $style;

        $tmp_expr = $style->{make_safe}->($tmp_expr);
        # Using functions makes us want answers with more precision than our inputs indicate.
        my $precision = ($query =~ $funcy) ? undef : max(map { $style->{precision}->($_) } @numbers);

        eval {
            # e.g. sin(100000)/100000 completely makes this go haywire.
            alarm(1);
            $tmp_result = eval($tmp_expr);
        };

        # Guard against non-result results
        return unless (defined $tmp_result && $tmp_result ne 'inf');
        # Try to determine if the result is supposed to be 0, but isn't because of FP issues.
        # If there's a defined precision, let sprintf worry about it.
        # Otherwise, we'll say that smaller than 1e-7 was supposed to be zero.
        $tmp_result = 0 if (not defined $precision and ($tmp_result =~ /e\-(?<exp>\d+)$/ and $+{exp} > 7));
        # Guard against very small floats which will not be rounded.
        # 0-9 check for http://yegg.duckduckgo.com/?q=%243.43%20%2434.45&format=json
        return unless (defined $precision || ($tmp_result =~ /^(?:\-|)[0-9\.]+$/));

        # Ok, this might be overkill on flexibility.
        $tmp_result = sprintf('%0' . $perl_style->{sub_decimal} . $precision . 'f', $tmp_result) if ($precision);
        # Dollars.
        $tmp_result = '$' . $tmp_result if ($query =~ /^\$/);

        # Query for display.
        my $tmp_q = $query;

        # Drop equals.
        $tmp_q =~ s/\=$//;
        $tmp_q =~ s/((?:\d+?|\s))E(-?\d+)/\($1 * 10^$2\)/;

        # Copy
        $results_no_html = $results_html = $tmp_q;

        # Superscript (before spacing).
        $results_html =~ s/\^([^\)]+)/<sup>$1<\/sup>/g;
        $results_html =~ s/\^(\d+|\b(?:$ored_constants)\b)/<sup>$1<\/sup>/g;

        ($results_no_html, $results_html) = map { spacing($_) } ($results_no_html, $results_html);
        return if $results_no_html =~ /^\s/;

        # Add proper separators.
        $tmp_result = $style->{make_pretty}->($tmp_result);

        # Now add = back.
        $results_no_html .= ' = ';
        $results_html    .= ' = ';

        $results_html =
          qq(<div>$results_html<a href="javascript:;" onClick="document.x.q.value='$tmp_result';document.x.q.focus();">$tmp_result</a></div>);
        return $results_no_html . $tmp_result,
          html    => $results_html,
          heading => "Calculator";
    }

    return;
};

#separates symbols with a space
#spacing '1+1'  ->  '1 + 1'
sub spacing {
    my ($text, $space_for_parse) = @_;

    $text =~ s/(\s*(?<!<)(?:[\+\-\^xX\*\/\%]|times|plus|minus|dividedby)+\s*)/ $1 /ig;
    $text =~ s/\s*dividedby\s*/ divided by /ig;
    $text =~ s/(\d+?)((?:dozen|pi|gross))/$1 $2/ig;
    $text =~ s/(\d+?)e/$1 e/g;    # E == *10^n
    $text =~ s/([\(\)\$])/ $1 /g if ($space_for_parse);

    return $text;
}

# Takes an array of numbers and returns which style to use for parse and display
# If there are conflicting answers among the array, will return undef.
sub display_style {
    my @numbers = @_;

    my $style;                    # By default, assume we don't understand the numbers.

    STYLE:
    foreach my $test_style (@known_styles) {
        if (all { $test_style->{fit_check}->($_) } @numbers) {
            # All of our numbers fit this style.  Since we have them in preference order
            # we can pick it and move on.
            $style = $test_style;
            last STYLE;
        }
    }
    return $style;
}

# Returns a function which evaluates whether a number fits a certain style.
sub _well_formed_for_style_func {
    my $style = shift;
    my ($decimal, $thousands) = ($style->{decimal}, $style->{thousands});

    return sub {
        my $number = shift;
        return (
            $number =~ /^[\d$thousands$decimal]+$/
              # Only contains things we understand.
              && ($number !~ /$thousands/ || ($number !~ /$thousands\d{1,2}\b/ && $number !~ /$thousands\d{4,}/))
              # You can leave out thousands breaks, but the ones you put in must be in the right place.
              # Note that this does not confirm that they put all the 'required' ones in.
              && ($number !~ /$decimal/ || $number !~ /$decimal(?:.*)?(?:$decimal|$thousands)/)
              # You can omit the decimal but you cannot have another decimal or thousands after:
        ) ? 1 : 0;
    };
}

# Returns function which given a number in a certain style, makes it nice for human eyes.
sub _display_style_func {
    my ($style, $perl_style) = @_;
    my ($decimal, $sub_decimal, $sub_thousands, $perl_dec) =
      (@{$style}{qw(decimal sub_decimal sub_thousands)}, $perl_style->{decimal});    # Unpacked for easier regex-building

    return sub {
        my $text = shift;
        $text = reverse $text;
        $text =~ s/$perl_dec/$sub_decimal/g;
        $text =~ s/(\d\d\d)(?=\d)(?!\d*$decimal)/$1$sub_thousands/g;

        return scalar reverse $text;
    };
}

# Returns function which given a number in a certain style, makes it safe for perl eval.
sub _prepare_for_computation_func {
    my ($style, $perl_style) = @_;
    my ($decimal, $thousands, $perl_dec) = (@{$style}{qw(decimal thousands)}, $perl_style->{sub_decimal});

    return sub {
        my $number_text = shift;

        $number_text =~ s/$thousands//g;           # Remove thousands seps, since they are just visual.
        $number_text =~ s/$decimal/$perl_dec/g;    # Make sure decimal mark is something perl knows how to use.

        return $number_text;
    };
}

# Returns function which given a number, determines the number of places after the decimal.
sub _precision_for_style_func {
    my ($style) = @_;
    my $decimal = $style->{decimal};

    return sub {
        my $number_text = shift;

        return ($number_text =~ /$decimal(\d+)/) ? length($1) : 0;
    };
}

1;
