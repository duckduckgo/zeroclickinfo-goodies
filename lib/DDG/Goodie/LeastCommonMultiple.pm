package DDG::Goodie::LeastCommonMultiple;
# ABSTRACT: Returns the least common multiple of the two numbers entered

use DDG::Goodie;
use strict;

zci answer_type => "least_common_multiple";
zci is_cached   => 1;

triggers startend => 'least common multiple', 'lcm';

primary_example_queries 'LCM 121 11';
secondary_example_queries '99 9 least common multiple';
description 'returns the least common multiple of the two entered numbers';
name 'LeastCommonMultiple';
topics 'math';
category 'calculations';
attribution github => [ 'https://github.com/shjnyr', 'Haojun Sui' ];

handle remainder => sub {

    return unless /^\s*\d+(?:(?:\s|,)+\d+)*\s*$/;

    # Here, $_ is a string of digits separated by whitespaces. And $_
    # holds at least one number.

    my @numbers = grep(/^\d/, split /(?:\s|,)+/);
    @numbers = sort { $a <=> $b } @numbers;

    my $formatted_numbers = join(', ', @numbers);
    $formatted_numbers =~ s/, ([^,]*)$/ and $1/;

    my $gcd = $numbers[0];
    foreach (@numbers) {
        $gcd = gcf($gcd, $_);
    }
    my $lcm = shift @numbers;
    foreach (@numbers) {
        $lcm *= $_ / $gcd;
    }

    return "Least common multiple of $formatted_numbers is $lcm.",
      structured_answer => {
        input     => [$formatted_numbers],
        operation => 'Least common multiple',
        result    => $lcm,
      };
};

sub gcf {
    my ($x, $y) = @_;
    ($x, $y) = ($y, $x % $y) while $y;
    return $x;
}

1;
