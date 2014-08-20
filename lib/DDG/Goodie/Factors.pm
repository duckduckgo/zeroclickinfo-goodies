package DDG::Goodie::Factors;
# ABSTRACT: Returns the factors of the entered number

use DDG::Goodie;

use Math::Prime::Util 'divisors';

zci answer_type => "factors";
zci is_cached => 1;

triggers startend => 'factors', 'factors of';

primary_example_queries 'factors of 30';
secondary_example_queries '72 factors';
description 'Returns the factors of the entered number';
name 'Factors';
topics 'math';
category 'calculations';
attribution github => [ 'https://github.com/austinheimark', 'austin_heimark' ];

handle remainder => sub {
	return unless /^\d+$/; 
	my @factors = divisors($_);
	return "Factors of $_: @factors";
};

1;
