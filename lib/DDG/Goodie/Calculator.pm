package DDG::Goodie::Calculator;
# ABSTRACT: do simple arthimetical calculations

use DDG::Goodie;

use List::Util qw( all first );

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
        (?: [\( \) x X * % + / \^ \$ -] | times | divided by | plus | minus | cos | sin | tan | cotan | log | ln | log10 | exp )+

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
    $style->{make_safe}   = _prepare_for_computation_func($style, $perl_style);
    $style->{make_pretty} = _display_style_func($style, $perl_style);
}

# This is not as good an idea as I might think.
# Luckily it will someday be able to be tokenized so this won't apply.
my $all_seps = join('', map { $_->{decimal} . $_->{thousands} } @known_styles);

my $numbery = qr/^[\d$all_seps]+$/;

handle query_nowhitespace => sub {
    my $results_html;
    my $results_no_html;
    my $query = $_;

    $query =~ s/^(?:whatis|calculate|solve|math)//;

    if ($query !~ /[xX]\s*[\*\%\+\-\/\^]/ && $query !~ /^-?[\d]{2,3}\.\d+,\s?-?[\d]{2,3}\.\d+$/) {
        my $tmp_result = '';

        # Grab expression.
        my $tmp_expr = $query;

        #do the following substitutions in $tmp_expr:
        #^ -> **
        #x|times -> *
        #minus ->  -
        #plus -> +
        #dividedby -> /
        $tmp_expr =~ s# \^          # ** #xg;
        $tmp_expr =~ s# (?:x|times) # *  #xig;
        $tmp_expr =~ s# minus       # -  #xig;
        $tmp_expr =~ s# plus        # +  #xig;
        $tmp_expr =~ s# dividedby   # \/ #xig;

        # sub in constants
        # e sub is lowercase only because E == *10^n
        $tmp_expr =~ s/ ((?:\d+?|\s))E(-?\d+)([^\d]) /\($1 * 10**$2\)$3                             /xg;
        $tmp_expr =~ s/ (\d+?)e([^A-Za-z])           /$1 * 2.71828182845904523536028747135266249 $2 /xg;
        $tmp_expr =~ s/ ([^A-Za-z])e([^A-Za-z])      /$1 2.71828182845904523536028747135266249 $2   /xg;
        $tmp_expr =~ s/ \be\b                        /2.71828182845904523536028747135266249         /xg;
        $tmp_expr =~ s/ (\d+?)c([^A-Za-z])           /$1 * 299792458 $2                             /xig;
        $tmp_expr =~ s/ ([^A-Za-z])c([^A-Za-z])      /$1 299792458 $2                               /xig;
        $tmp_expr =~ s/ \bc\b                        /299792458                                     /xig;
        $tmp_expr =~ s/ (\d+?)pi                     /$1 * 3.14159265358979323846264338327950288    /xig;
        $tmp_expr =~ s/ pi                           /3.14159265358979323846264338327950288         /xig;
        $tmp_expr =~ s/ (\d+?)gross                  /$1 * 144                                      /xig;
        $tmp_expr =~ s/ (\d+?)dozen                  /$1 * 12                                       /xig;
        $tmp_expr =~ s/ dozen                        /12                                            /xig;
        $tmp_expr =~ s/ gross                        /144                                           /xig;

        $tmp_expr =~ s/\$//g;    # Remove $s.
                                 # To be converted to display_style upon refactoring.
        my @numbers = grep { $_ =~ $numbery } (split /\s+/, spacing($tmp_expr, 1));
        my $style = display_style(@numbers);
        return unless $style;
        $tmp_expr = $style->{make_safe}->($tmp_expr);

        # Drop =.
        $tmp_expr =~ s/=$//;

        # Drop leading 0s.
        # 2011.11.09 fix for 21 + 15 x 0 + 5
        $tmp_expr =~ s/(?<!\.)(?<![0-9])0([1-9])/$1/;

        eval {
            # e.g. sin(100000)/100000 completely makes this go haywire.
            alarm(1);
            $tmp_result = eval($tmp_expr);
        };

        # 0-9 check for http://yegg.duckduckgo.com/?q=%243.43%20%2434.45&format=json
        if (defined $tmp_result && $tmp_result ne 'inf' && $tmp_result =~ /^(?:\-|)[0-9\.]+$/) {
            # Precisian.
            my $precisian = 0;

            # too clever -- .5 ^ 2 not working right.
            if (0) {
                while ($query =~ /\.(\d+)/g) {
                    my $decimal = length($1);
                    $precisian = $decimal if $decimal > $precisian;
                }

                $tmp_result = sprintf('%0.' . $precisian . 'f', $tmp_result) if $precisian;
            }

            # Dollars.
            if ($query =~ /^\$/) {
                $tmp_result = qq(\$$tmp_result);
            }

            # Query for display.
            my $tmp_q = $query;

            # Drop equals.
            $tmp_q =~ s/\=$//;
            $tmp_q =~ s/((?:\d+?|\s))E(-?\d+)/\($1 * 10^$2\)/;

            # Copy
            $results_no_html = $results_html = $tmp_q;

            # Superscript (before spacing).
            $results_html =~ s/\^([^\)]+)/<sup>$1<\/sup>/g;
            $results_html =~ s/\^(\d+|\b(?:e|c|dozen|gross|pi)\b)/<sup>$1<\/sup>/g;

            ($results_no_html, $results_html) = (spacing($results_no_html), spacing($results_html));
            return if $results_no_html =~ /^\s/;

            # Add commas.
            $tmp_result = $style->{make_pretty}->($tmp_result);

            # Now add it back.
            $results_no_html .= ' = ';
            $results_html    .= ' = ';

            $results_html =
              qq(<div>$results_html<a href="javascript:;" onClick="document.x.q.value='$tmp_result';document.x.q.focus();">$tmp_result</a></div>);
            return $results_no_html . $tmp_result,
              html    => $results_html,
              heading => "Calculator";
        }
    }

    return;
};

#extra math functions
sub tan {
    my $x = $_[0];
    return sin($x) / cos($x);
}

sub cotan {
    my $x = $_[0];
    return cos($x) / sin($x);
}

sub log10 {
    my $x = $_[0];
    return log($x) / log(10);
}

#separates symbols with a space
#spacing '1+1'  ->  '1 + 1'
sub spacing {
    my ($text, $space_parens) = @_;

    $text =~ s/(\s*(?<!<)(?:[\+\-\^xX\*\/\%]|times|plus|minus|dividedby)+\s*)/ $1 /ig;
    $text =~ s/dividedby/divided by/ig;
    $text =~ s/(\d+?)((?:dozen|pi|gross|e|c))/$1 $2/ig;
    $text =~ s/\bc\b/speed of light/ig;
    $text =~ s/([\(\)])/ $1 /g if ($space_parens);

    return $text;
}

# Takes an array of numbers and returns which style to use for parse and display
# If there are conflicting answers among the array, will return undef.
sub display_style {
    my @numbers = @_;

    my $style;    # By default, assume we don't understand the numbers.

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
              # You can not have a decimal but if you do it cannot be followed by another decimal or thousands
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

1;
