package DDG::Goodie::PrimeFactors;
#Returns all the prime factors of the entered number

use DDG::Goodie;
use Math::Prime::Util 'factor';

zci answer_type => "prime_factors";
zci is_cached => 1;

triggers startend => 'prime factors', 'prime factors of';

primary_example_queries 'prime factors of 30';
secondary_example_queries '72 prime factors';
description 'Returns the prime factors of the entered number';
name 'PrimeFactors';
topics 'math';
category 'calculations';
attribution github => [ 'https://github.com/austinheimark', 'austin_heimark' ];

handle remainder => sub {
	return unless /^\d+$/;
	my @factors = factor($_);

	my $result = "Prime factors of $_ is @factors.";
	
	return $result, 'html' => "$result";
};

1;
