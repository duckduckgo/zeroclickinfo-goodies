package DDG::Goodie::SumOfNaturalNumbers;
# ABSTRACT: Returns the sum of the numbers between the first and second provided integers

use DDG::Goodie;
use bignum;

triggers start => "add", "sum from";
triggers startend => "sum";

zci is_cached => 1;
zci answer_type => "sum";

primary_example_queries 'sum 1 to 10';
secondary_example_queries 'add 33 to 100';
description 'Add up the numbers between two values';
name 'SumOfNaturalNumbers';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/SumOfNaturalNumbers.pm';
category 'calculations';
topics 'math';
attribution github => ['JulianGindi', 'Julian Gindi'],
            github => ['navneet35371', 'Navneet Suman'];

# This adds commas to the number.
# It converts 10000000 to 10,000,000.
# It was copied from http://perldoc.perl.org/perlfaq5.html#How-can-I-output-my-numbers-with-commas-added%3f
sub commify {
    # Disable bigint in this function. It interferes with `1 while ...`.
    no bigint;
    local $_  = shift;
    1 while s/^([-+]?\d+)(\d{3})/$1,$2/;
    return $_;
}

handle remainder => sub {
    # Check if we're getting integers.
    return unless $_ =~ /^(?:from )?(\d+)\s*(to|-)\s*(\d+)$/i;

    if ($1 > $3) {
	return;
    } else {
	my $sum = ((($3 * ($3 + 1)) / 2)-(($1 * ($1 - 1)) / 2));
	return 'Sum of natural numbers from ' . commify($1) . ' to ' . commify($3) . ' is ' . commify($sum) . '.';
    }
};

1;
