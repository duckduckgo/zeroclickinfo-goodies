package DDG::Goodie::LowestCommonMultiple;


use strict;
use DDG::Goodie;

zci answer_type => "greatest_common_factor";
zci is_cached   => 1;
triggers startend => 'lowest common multiple', 'lowest common multiple of', 'lcm','lcm of','least common multiple';

handle remainder => sub {



    return unless /^\s*\d+(?:(?:\s|,)+\d+)*\s*$/;



    # Here, $_ is a string of digits separated by whitespaces. And $_

    # holds at least one number.



    my @numbers = grep(/^\d/, split /(?:\s|,)+/);

    @numbers = sort { $a <=> $b } @numbers;



    my $formatted_numbers = join(', ', @numbers);

    $formatted_numbers =~ s/, ([^,]*)$/ and $1/;



    my $result = shift @numbers;

    foreach (@numbers) {

        $result = lcm($result, $_)

    }



    return "Lowest Common Multiple of $formatted_numbers is $result.",

      structured_answer => {

        input     => [$formatted_numbers],

        operation => 'Lowest Common Multiple',

        result    => $result

      };

};



sub lcm {

    my ($x, $y) = @_;

	my $z = $x*$y;

    ($x, $y) = ($y, $x % $y) while $y;

    return $z/$x;

}



1;
