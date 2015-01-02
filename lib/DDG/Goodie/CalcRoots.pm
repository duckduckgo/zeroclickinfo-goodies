package DDG::Goodie::CalcRoots;
# ABSTRACT: compute the n-th root of a number

use DDG::Goodie;
use Lingua::EN::Numericalize;

primary_example_queries 'square root of 9';
description 'calculate the nth root';
name 'CalcRoots';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodie/blob/master/lib/DDG/Goodie/CalcRoots.pm';
attribution github => ['https://github.com/duckduckgo', 'duckduckgo'];
category 'calculations';
topics 'math';

triggers any => 'root';

zci is_cached => 1;

zci answer_type => 'root';

handle query  => sub {
    # The 'root' trigger is very ambigous so this regex provides the specific triggers
    return unless  m/^((?:.*square|.*cube(?:d|)|.*th|.*rd|.*nd|.*st|.*[0-9]+)) root(?: of|) (?!of)(.*)/i;

    # Common phrases that won't be caught by str2nbr()
    my %function = (
        'square' => 2,
        'cubed' => 3,
        'cube' => 3,
    );

    # Seperate the exponent and base courtesy of the above regex
    my $exp = $1;
    my $base = $2;

    # Figure out what number the exponent is
    if ($exp =~ m/negative\s|minus\s|\A-/i) {
        $exp = $function{$'} ? $function{$'} * -1 : str2nbr($') * -1;
    }
    else {
        $exp = $function{$exp} ? $function{$exp} : str2nbr($exp);
    }

    # You can't take a zeroeth root
    return if $exp == 0;


    # There are separate cases here.
    # 1. Negative base and even exponent (imaginary numbers)
    # 2. Negative base and odd exponenet
    # 3. Positive base

    if ($base =~ m/negative\s|minus\s|\A-/i && $exp % 2 == 0) {

        # Figure out what number the base is
        $base = $';
        $base =  str2nbr($base) if $base =~ /[^0-9]/;

        # Solve using  the absolute value of the base
        $base = abs($base);
        my $calc = $base ** (1/$exp);

        # If the result is a whole number (n), the answer is n*i
        if (($calc - int($calc)) == 0) {
            return $calc . 'i', html => "<sup>$exp</sup>&radic;-$base = $calc<em>i</em>";
        }

        # Try and simplify the radical
        my $count = int($calc);

        while ($count > 1) {

            # See if the current number raised to the given exponent is a factor of our base. If it is, the answer is n * i * exponent-root(the other factor)
            my $newBase = $base / ($count ** $exp);

            if ( ($newBase - int($newBase)) == 0) {
                return "The $exp-root of -$base is $count * i * the $exp-root of $newBase.", html=> "<sup>$exp</sup>&radic;-$base = $count<em>i</em>&sdot;<sup>$exp</sup>&radic;$newBase";
            }

            $count--;
        }

        # Can't be solved or simplified via the above methods
        return "The $exp-root of -$base is i * the $exp-root of $base", html => "<sup>$exp</sup>&radic;-$base = <em>i</em>&sdot;<sup>$exp</sup>&radic;$base";
    }
    elsif ($base =~ m/negative\s|minus\s|\A-/i && $exp % 2 != 0) {

        # Solve normally
        $base = $';
        $base = str2nbr($base) if $base  =~  m/[^0-9]/;
        $base =~ s/[^0-9\.]//g;
        if ($base ne '') {

            my $calc = $base ** (1/$exp) * -1;

            # Try and simplify the radical
            my $count = int(abs($calc));

            while ($count > 1) {

                # See if the current number raised to the given exponent is a factor of our base. If it is, we can give them a simplified version of the radical in addition to the answer.
                my $newBase = $base / ($count ** $exp);

                if ( ($newBase - int($newBase)) == 0) {
                    return "The $exp-root of -$base is $calc (-$count times the $exp-root of $newBase).", html=> qq|<sup>$exp</sup>&radic;-$base = <a href="javascript:;" onclick="document.x.q.value='$calc';document.x.q.focus();">$calc</a> (-$count&sdot;<sup>$exp</sup>&radic;$newBase)|;
                }

                $count--;
            }

            return "The $exp-root of -$base is $calc.", html=> qq|<sup>$exp</sup>&radic;-$base = <a href="javascript:;" onclick="document.x.q.value='$calc';document.x.q.focus();">$calc</a>|;
        }
    }
    elsif ($exp =~ m/[0-9]+/) {

        # Solve normally
        $base = str2nbr($base) if $base =~ m/[^0-9]/;
        $base =~ s/[^0-9\.]//g;
        if ($base ne '') {
            my $calc = $base ** (1/$exp);

            # Try and simplify the radical
            my $count = int($calc);

            while ($count > 1) {

                # See if the current number raised to the given exponent is a factor of our base. If it is, we can give them a simplified version of the radical in addition to the answer.
                my $newBase = $base / ($count ** $exp);

                if ( ($newBase - int($newBase)) == 0) {
                    return "The $exp-root of $base is $calc ($count times the $exp-root of $newBase).", html=> qq|<sup>$exp</sup>&radic;$base =  <a href="javascript:;" onclick="document.x.q.value='$calc';document.x.q.focus();">$calc</a> ($count&sdot;<sup>$exp</sup>&radic;$newBase)|;
                }

                $count--;
            }

            return "The $exp-root of $base is $calc.", html => qq|<sup>$exp</sup>&radic;$base = <a href="javascript:;" onclick="document.x.q.value='$calc';document.x.q.focus();">$calc</a>|;
        }
    }

    return;
};

1;
