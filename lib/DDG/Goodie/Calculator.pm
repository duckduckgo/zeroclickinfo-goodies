package DDG::Goodie::Calculator;
# ABSTRACT: do simple arthimetical calculations

use DDG::Goodie;

use List::Util qw( all );

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
sub known_styles {
    return (
        perl => {
            decimal       => qr/\./,
            sub_decimal   => '.',
            thousands     => qr/,/,
            sub_thousands => ',',
        },
        euro => {
            decimal       => qr/,/,
            sub_decimal   => ',',
            thousands     => qr/\./,
            sub_thousands => '.',
        },
    );
}
my %known_styles   = known_styles();        # This bit of indirection is to make testing easier for now.
my $default_style  = $known_styles{perl};
my $safe_thousands = '_';

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
        my $style = $known_styles{determine_number_style($tmp_expr) // 'perl'};
        my ($decimal, $thousands, $perl_dec) = (@{$style}{qw(decimal thousands)}, $known_styles{perl}->{sub_decimal});
        $tmp_expr =~ s/$thousands/$safe_thousands/g;                     # Convert thousands separators to something safe for perl to ignore;
        $tmp_expr =~ s/$decimal/$perl_dec/g;                             # Make sure decimal mark is something perl knows how to use.

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
            $tmp_result = commify($tmp_result, $style);

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

#function to add appropriate thousands and decimal separators
sub commify {
    my ($text, $style) = @_;

    my ($decimal, $sub_decimal, $sub_thousands, $perl_dec) =
      (@{$style}{qw(decimal sub_decimal sub_thousands)},  $known_styles{perl}->{decimal});    #Unpack for easier regex-building
    $text = reverse $text;
    $text =~ s/$perl_dec/$sub_decimal/g;                   # Give them the decimal they expect
    $text =~ s/(\d\d\d)(?=\d)(?!\d*$decimal)/$1$sub_thousands/g;

    return scalar reverse $text;
}

#separates symbols with a space
#spacing '1+1'  ->  '1 + 1'
sub spacing {
    my $text = shift;
    $text =~ s/(\s*(?<!<)(?:[\+\-\^xX\*\/\%]|times|plus|minus|dividedby)+\s*)/ $1 /ig;
    $text =~ s/dividedby/divided by/ig;
    $text =~ s/(\d+?)((?:dozen|pi|gross|e|c))/$1 $2/ig;
    $text =~ s/\bc\b/speed of light/ig;

    return $text;
}

# This looks at a single number and determines the style in which it was entered.
# If it is ambiguous, then it returns undef.
sub determine_number_style {
    my $number = shift;

    my $disambiguated;
    my @styles = keys %known_styles;    # We need to do this here, because we are going shift off.

    while (not $disambiguated and my $test_style = shift @styles) {
        my ($decimal, $thousands) = @{$known_styles{$test_style}}{qw(decimal thousands)};    #Unpack for easier regex-building
        if ((
                ( $number =~ /^\d{1,3}($thousands\d{3})+$decimal/)
                # All thousands appear to be separating thousands and
                # both present in the right order so we have an easy match.
                || (   $number !~ /$thousands/
                    && $number =~ /$decimal/
                    && $number !~ /$decimal\d{3}$/)
                # No thousands sep, a decimal sep, but not with exactly 3 numbers after.
                || ($number !~ /$decimal/ && $number =~ /$thousands\d+?$thousands/)
                # No decimal separator, multiple thousands separators.
                || ($number =~ /^$decimal/)
                # Starts with a decimal, no leading 0
            )
            && $number !~ /\d+?$decimal\d+?($decimal|$thousands)/
            # Sanity-check: cannot have more than one decimal mark or have thousands after the decimal
          )
        {
            $disambiguated = $test_style;
        }
    }

    return $disambiguated;
}

# Takes an array of numbers and returns which format to use for display
# If there are conflicting answers among the array, will return undef.
# If they are all ambiguous, will return the default style.

sub display_style {
    my @numbers = @_;

    my $style;
    # undef is ambiguous, we'll worry about that below
    my @used_styles = grep { $_ } map { determine_number_style($_) } @numbers;
    my $unambig_count = scalar @used_styles;

    if ($unambig_count == 0) {
        # everything was ambiguous, use the default style
        $style = $default_style;
    } elsif ($unambig_count == 1) {
        # Only one is unambiguous, so use that format.
        $style = $known_styles{$used_styles[0]};
    } else {
        my $first_style = shift @used_styles;
        if (all { $_ eq $first_style } @used_styles) {
            # They all match, so we can pick it.
            $style = $known_styles{$first_style};
        }
    }

    if ($style) {
        # We've decided that everything unambiguous fits the style.
        # Now we need to make sure that all of the numbers are well-formed
        # under this style.
        my $fits_style = _well_formed_for_style_func($style);
        $style = undef unless (all { $fits_style->($_) } @numbers);
        # Considering the above line and all the 'not'ing in the func I think
        # I may have missed out on one of DeMorgan's Laws somewhere
    }

    return $style;
}

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

1;
