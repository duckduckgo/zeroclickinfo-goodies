package DDG::Goodie::Factors;
#Returns the factors of the entered number

use DDG::Goodie;
use Math::Prime::Util 'all_factors';

zci answer_type => "factors";

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
	my @factors = all_factors($_);
	return "Factors of $_: 1 @factors $_";
};

1;
