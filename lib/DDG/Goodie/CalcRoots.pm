package DDG::Goodie::CalcRoots;
# ABSTRACT: compute the n-th root of a number

use strict;
use DDG::Goodie;
use Lingua::EN::Numericalize;

triggers any => 'root';

zci is_cached => 1;

zci answer_type => 'root';

my $UPPER_BOUND = 1000000000; # 1 Billion

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
    my $sign = "";

    # Figure out what number the exponent is
    if ($exp =~ m/negative\s|minus\s|\A-/i) {
        $sign = "-";
        $exp = $function{$'} ? $function{$'} : str2nbr($');
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
        return unless $base =~ /[0-9]+/;

        # Solve using  the absolute value of the base
        $base = abs($base);
        return unless $base < $UPPER_BOUND;
        my $calc = $base ** (1/$exp);
        if($sign eq "-"){$calc = -$calc;}

        # If the result is a whole number (n), the answer is n*i
        if (($calc - int($calc)) == 0) {
            return structured($sign . $exp, "-$base","The $sign$exp-root of -$base is $calc i", "$sign<sup>$exp</sup>&radic;-$base = $calc<em>i</em>");
        }

        # Try and simplify the radical
        my $count = int(abs($calc));

        while ($count > 1) {

            # See if the current number raised to the given exponent is a factor of our base. If it is, the answer is n * i * exponent-root(the other factor)
            my $newBase = $base / ($count ** $exp);

            if ( ($newBase - int($newBase)) == 0) {
                return structured($sign . $exp,"-$base","The $sign$exp-root of -$base is $count * i * the $sign$exp-root of $newBase.", "$sign<sup>$exp</sup>&radic;-$base = $sign$count<em>i</em>&sdot;<sup>$exp</sup>&radic;$newBase");
            }

            $count--;
        }

        # Can't be solved or simplified via the above methods
        return structured($sign . $exp,"-$base","The $sign$exp-root of -$base is i * the $sign$exp-root of $base", "$sign<sup>$exp</sup>&radic;-$base = $sign<em>i</em>&sdot;<sup>$exp</sup>&radic;$base");
    }
    elsif ($base =~ m/negative\s|minus\s|\A-/i && $exp % 2 != 0) {

        # Solve normally
        $base = $';
        $base = str2nbr($base) if $base  =~  m/[^0-9]/;
        $base =~ s/[^0-9\.]//g;
        return unless $base ne '' && $base < $UPPER_BOUND;

        my $calc = $base ** (1/$exp) * -1;
        if($sign eq "-"){$calc = -$calc;}

        my $secondsign = "-"; #sign of the calcuated answer
        if($calc>0){$secondsign="";}

        # Try and simplify the radical if answer is not a whole number
        unless(($calc - int($calc))==0){
            my $count = int(abs($calc));
            while ($count > 1) {

                # See if the current number raised to the given exponent is a factor of our base. If it is, we can give them a simplified version of the radical in addition to the answer.
                my $newBase = $base / ($count ** $exp);

                if ( ($newBase - int($newBase)) == 0) {
                    return structured($sign . $exp,"-$base","The $sign$exp-root of -$base is $calc ($secondsign$count times the $sign$exp-root of $newBase).", qq|$sign<sup>$exp</sup>&radic;-$base = <a href="javascript:;" onclick="document.x.q.value='$calc';document.x.q.focus();">$calc</a> ($secondsign$count&sdot;<sup>$exp</sup>&radic;$newBase)|);
                }

                $count--;
            }
        }
        return structured($sign . $exp,"-$base","The $sign$exp-root of -$base is $calc.", qq|$sign<sup>$exp</sup>&radic;-$base = <a href="javascript:;" onclick="document.x.q.value='$calc';document.x.q.focus();">$calc</a>|);
    }
    elsif ($exp =~ m/[0-9]+/) {

        # Solve normally
        $base = str2nbr($base) if $base =~ m/[^0-9]/;
        $base =~ s/[^0-9\.]//g;
        return unless $base ne '' && $base < $UPPER_BOUND;

        my $calc = $base ** (1/$exp);
        if($sign eq "-"){$calc = -$calc;}

        #If the answer is not a whole number, try to simplify the radical
        unless(($calc - int($calc))==0){
            my $count = int(abs($calc));
            while ($count > 1) {

                # See if the current number raised to the given exponent is a factor of our base. If it is, we can give them a simplified version of the radical in addition to the answer.
                my $newBase = $base / ($count ** $exp);

                if ( ($newBase - int($newBase)) == 0) {
                    return structured($sign . $exp,$base,"The $sign$exp-root of $base is $calc ($sign$count times the $exp-root of $newBase).", qq|$sign<sup>$exp</sup>&radic;$base =  <a href="javascript:;" onclick="document.x.q.value='$calc';document.x.q.focus();">$calc</a> ($sign$count&sdot;<sup>$exp</sup>&radic;$newBase)|);
                }

                $count--;
            }
        }
        return structured($sign . $exp,$base,"The $sign$exp-root of $base is $calc.", qq|$sign<sup>$exp</sup>&radic;$base = <a href="javascript:;" onclick="document.x.q.value='$calc';document.x.q.focus();">$calc</a>|);
    }

    return;
};

sub structured{
    my($exp,$base,$text, $html) = @_;
    return $text,
        structured_answer => {
            data => {
                title    => $html,
                subtitle => "Calculate $exp-root of $base",
            },
            templates => {
                group   => 'text',
                options => {
                    title_content => 'DDH.calc_roots.title',
                },
            },
        };
}

1;
