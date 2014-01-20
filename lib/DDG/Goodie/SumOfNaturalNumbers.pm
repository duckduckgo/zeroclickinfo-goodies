package DDG::Goodie::SumOfNaturalNumbers;
# ABSTRACT: Returns the sum of the numbers between the first and second provided integers

use DDG::Goodie;
use List::Util qw(reduce);

triggers start => "sum", "add";

zci is_cached => 1;
zci answer_type => "sum";

primary_example_queries 'sum 1 to 10';
secondary_example_queries 'add 33 to 100';
description 'Add up the numbers between two values';
name 'SumOfNaturalNumbers';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/SumOfNaturalNumbers.pm';
category 'calculations';
topics 'math';

handle remainder => sub {
  return unless $_ =~ /^(\d+)\s+\bto\b\s+(\d+)/i;
  if ($1 > $2) {
    return;
  } else {
    my @numberArray = ($1..$2);
    my $sum = reduce { $a + $b } @numberArray;
    return "Sum: $sum";
  }
};

1
