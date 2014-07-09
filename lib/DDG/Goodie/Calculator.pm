package DDG::Goodie::Calculator;
# ABSTRACT: do simple arthimetical calculations

use feature 'state';

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
        (?: gross | dozen | pi | e | c | squared | score |)
        [\( \) x X * % + / \^ 0-9 \. , \$ -]*

        (?(1) (?: -? [0-9 \. ,]+ |) |)
        (?: [\( \) x X * % + / \^ \$ -] | times | divided by | plus | minus | cos | sin | tan | cotan | log | ln | log[_]?\d{1,3} | exp | tanh | sec | csc | squared )+

        (?: [0-9 \. ,]* )
        (?: gross | dozen | pi | e | c | squared | score |)

        [\( \) x X * % + / \^ 0-9 \. , \$ -]* =? 

        $
        >xi;

# This is probably YAGNI territory, but since I have to reference it in two places
# and there are a multitude of other notation systems (although some break the
# 'thousands' assumption) I am going to pretend that I do need it.
#  If it could fit more than one the first in order gets preference.
my @known_styles = ({
        id        => 'perl',
        decimal   => '.',
        thousands => ',',
    },
    {
        id        => 'euro',
        decimal   => ',',
        thousands => '.',
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

my $numbery = qr/[\d$all_seps]+/;
my $funcy   = qr/[[a-z]+\(|log[_]?\d{1,3}\(|\^|\/|\*/;    # Stuff that looks like functions.

my %named_operations = (
    '\^'          => '**',
    'x'           => '*',
    'times'       => '*',
    'minus'       => '-',
    'plus'        => '+',
    'divided\sby' => '/',
    'ln'          => 'log',                         # perl log() is natural log.
    'squared'     => '**2',
);

my %named_constants = (
    dozen => 12,
    e     => 2.71828182845904523536028747135266249,    # This should be computed.
    pi    => pi,                                       # pi constant from Math::Trig
    gross => 144,
    score => 20,
);

my $ored_constants = join('|', keys %named_constants);    # For later substitutions

handle query_nowhitespace => sub {
    my $results_html;
    my $results_no_html;
    my $query = $_;

    return if ($query =~ /\b0x/);    # Probable attempt to express a hexadecimal number, query_nowhitespace makes this overreach a bit.

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

        my @numbers = grep { $_ =~ /^$numbery$/ } (split /\s+/, $tmp_expr);
        my $style = display_style(@numbers);
        return unless $style;

        $tmp_expr = $style->{make_safe}->($tmp_expr);
        # Using functions makes us want answers with more precision than our inputs indicate.
        my $precision = ($query =~ $funcy) ? undef : max(map { $style->{precision}->($_) } @numbers);

        eval {
            # e.g. sin(100000)/100000 completely makes this go haywire.
            alarm(1);
            $tmp_result = eval($tmp_expr);
            alarm(0);    # Assume the string processing will be "fast enough"
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
        $tmp_result = sprintf('%0' . $perl_style->{decimal} . $precision . 'f', $tmp_result) if ($precision);
        # Dollars.
        $tmp_result = '$' . $tmp_result if ($query =~ /^\$/);

        # Add proper separators.
        $tmp_result = $style->{make_pretty}->($tmp_result);

        my $results = prepare_for_display($query, $tmp_result);

        return if $results->{text} =~ /^\s/;
        return $results->{text},
          html    => $results->{html},
          heading => "Calculator";
    }

    return;
};

sub prepare_for_display {
    my ($query, $result) = @_;

    # Equals varies by output type.
    $query =~ s/\=$//;
    # Show them how 'E' was interpreted.
    $query =~ s/((?:\d+?|\s))E(-?\d+)/\($1 * 10^$2\)/;

    return {
        text => format_text($query, $result),
        html => format_html($query, $result),
    };
}

# Format query for HTML
sub format_html {
    my ($query, $result) = @_;

    state $css = '<style type="text/css">' . share("style.css")->slurp . '</style>';

    $query = _add_html_exponents($query);

    return
        $css
      . "<div class='zci--calculator'>"
      . spacing($query)
      . " = <a href='javascript:;' onclick='document.x.q.value=\"$result\";document.x.q.focus();'>"
      . $result
      . "</a></div>";
}

sub _add_html_exponents {

    my $string = shift;

    return $string if ($string !~ /\^/ or $string =~ /^\^|\^$/);    # Give back the same thing if we won't deal with it properly.

    my @chars = split //, $string;
    my ($start_tag, $end_tag) = ('<sup>', '</sup>');
    my ($newly_up, $in_exp_number, $in_exp_parens, %power_parens);
    my ($parens_count, $number_up) = (0, 0);

    # because of associativity and power-to-power, we need to scan nearly the whole thing
    for my $index (1 .. $#chars - 1) {
        my $this_char = $chars[$index];
        if ($this_char =~ $numbery) {
            if ($newly_up) {
                $in_exp_number = 1;
                $newly_up      = 0;
            }
        } elsif ($this_char eq '(') {
            $parens_count += 1;
            $in_exp_number = 0;
            if ($newly_up) {
                $in_exp_parens += 1;
                $power_parens{$parens_count} = 1;
                $newly_up = 0;
            }
        } elsif ($this_char eq '^') {
            $chars[$index - 1] =~ s/$end_tag$//;    # Added too soon!
            $number_up += 1;
            $newly_up      = 1;
            $chars[$index] = $start_tag;            # Replace ^ with the tag.
        } elsif ($in_exp_number) {
            $in_exp_number = 0;
            $number_up -= 1;
            $chars[$index] = $end_tag . $chars[$index];
        } elsif ($number_up && !$in_exp_parens) {
            # Must have ended another term or more
            $chars[$index] = ($end_tag x ($number_up - 1)) . $chars[$index];
            $number_up = 0;
        } elsif ($this_char eq ')') {
            # We just closed a set of parens, see if it closes one of our things
            if ($in_exp_parens && $power_parens{$parens_count}) {
                $chars[$index] .= $end_tag;
                delete $power_parens{$parens_count};
                $in_exp_parens -= 1;
            }
            $parens_count -= 1;
        }
    }
    $chars[-1] .= $end_tag x $number_up if ($number_up);

    return join('', @chars);
}

# Format query for text
sub format_text {
    my ($query, $result) = @_;

    return spacing($query) . ' = ' . $result;
}

#separates symbols with a space
#spacing '1+1'  ->  '1 + 1'
sub spacing {
    my ($text, $space_for_parse) = @_;

    $text =~ s/(\s*(?<!<)(?:[\+\-\^xX\*\/\%]|times|plus|minus|dividedby)+\s*)/ $1 /ig;
    $text =~ s/\s*dividedby\s*/ divided by /ig;
    $text =~ s/(\d+?)((?:dozen|pi|gross|squared|score))/$1 $2/ig;
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
            $number =~ /^(\d|\Q$thousands\E|\Q$decimal\E)+$/
              # Only contains things we understand.
              && ($number !~ /\Q$thousands\E/ || ($number !~ /\Q$thousands\E\d{1,2}\b/ && $number !~ /\Q$thousands\E\d{4,}/ && $number !~ /^0\Q$thousands\E/))
              # You can leave out thousands breaks, but the ones you put in must be in the right place
              # which does not include following an initial 0.
              # Note that this does not confirm that they put all the 'required' ones in.
              && ($number !~ /\Q$decimal\E/ || $number !~ /\Q$decimal\E(?:.*)?(?:\Q$decimal\E|\Q$thousands\E)/)
              # You can omit the decimal but you cannot have another decimal or thousands after:
        ) ? 1 : 0;
    };
}

# Returns function which given a number in a certain style, makes it nice for human eyes.
sub _display_style_func {
    my ($style, $perl_style) = @_;
    my ($decimal, $thousands, $perl_dec) = (@{$style}{qw(decimal thousands)}, $perl_style->{decimal});    # Unpacked for easier regex-building

    return sub {
        my $text = shift;
        $text = reverse $text;
        $text =~ s/\Q$perl_dec\E/$decimal/g;
        $text =~ s/(\d\d\d)(?=\d)(?!\d*\Q$decimal\E)/$1$thousands/g;

        return scalar reverse $text;
    };
}

# Returns function which given a number in a certain style, makes it safe for perl eval.
sub _prepare_for_computation_func {
    my ($style, $perl_style) = @_;
    my ($decimal, $thousands, $perl_dec) = (@{$style}{qw(decimal thousands)}, $perl_style->{decimal});

    return sub {
        my $number_text = shift;

        $number_text =~ s/\Q$thousands\E//g;           # Remove thousands seps, since they are just visual.
        $number_text =~ s/\Q$decimal\E/$perl_dec/g;    # Make sure decimal mark is something perl knows how to use.

        return $number_text;
    };
}

# Returns function which given a number, determines the number of places after the decimal.
sub _precision_for_style_func {
    my ($style) = @_;
    my $decimal = $style->{decimal};

    return sub {
        my $number_text = shift;

        return ($number_text =~ /\Q$decimal\E(\d+)/) ? length($1) : 0;
    };
}

1;
