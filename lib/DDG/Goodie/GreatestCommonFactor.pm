package DDG::Goodie::GreatestCommonFactor;
# ABSTRACT: Returns the greatest common factor of the two numbers entered

use strict;
use DDG::Goodie;

zci answer_type => "greatest_common_factor";
zci is_cached   => 1;

triggers startend => 'greatest common factor', 'gcf', 'greatest common divisor', 'gcd';

primary_example_queries 'GCF 121 11';
secondary_example_queries '99 9 greatest common factor';
description 'returns the greatest common factor of the two entered numbers';
name 'GreatestCommonFactor';
topics 'math';
category 'calculations';
attribution github => [ 'https://github.com/austinheimark', 'Austin Heimark' ];

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
        $result = gcf($result, $_)
    }

    return "Greatest common factor of $formatted_numbers is $result.",
      structured_answer => {
        input     => [$formatted_numbers],
        operation => 'Greatest common factor',
        result    => $result
      };
};

sub gcf {
    my ($x, $y) = @_;
    ($x, $y) = ($y, $x % $y) while $y;
    return $x;
}

1;
