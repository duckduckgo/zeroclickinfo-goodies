package DDG::Goodie::GreatestCommonFactor;
# ABSTRACT: Returns the greatest common factor of the two numbers entered

use DDG::Goodie;

zci answer_type => "greatest_common_factor";
zci is_cached   => 1;

triggers startend => 'greatest common factor', 'GCF', 'gcf';

primary_example_queries 'GCF 121 11';
secondary_example_queries '99 9 greatest common factor';
description 'returns the greatest common factor of the two entered numbers';
name 'GreatestCommonFactor';
topics 'math';
category 'calculations';
attribution github => [ 'https://github.com/austinheimark', 'Austin Heimark' ];

handle remainder => sub {

    return unless /^(?<fn>\d+)\s(?<sn>\d+)$/;

    my ($first, $second) = sort { $a <=> $b } ($+{'fn'}, $+{'sn'});
    my $result = gcf($first, $second);

    return 'Greatest common factor of ' . $first . ' and ' . $second . ' is ' . $result . '.',
      structured_answer => {
        input     => [$first, $second],
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
