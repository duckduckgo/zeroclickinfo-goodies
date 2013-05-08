package DDG::Goodie::LeastCommonMultiple;
#Returns the least common multiple of the two numbers entered

use DDG::Goodie;

zci answer_type => "least_common_multiple";
zci is_cached => 1;

triggers startend => 'least common multiple', 'lcm';

primary_example_queries 'lcm 121 11';
secondary_example_queries '99 9 least common multiple';
description 'returns the least common multiple of the two entered numbers';
name 'LeastCommonMultiple';
topics 'math';
category 'calculations';
attribution github => [ 'https://github.com/austinheimark', 'austin_heimark' ];

handle remainder => sub {
	sub gcf {
		my ($x, $y) = @_;
		($x, $y) = ($y, $x % $y) while $y;
		return $x;	
	}

	sub lcm {
		return($_[0] * $_[1] / gcf($_[0], $_[1]));
	}

	if ($_ =~ /^(\d+)\s(\d+)$/) {
		return 'Least common multiple of ' . $1 . ' and ' . $2 . ': ' . lcm($1,$2);	
	} else {
		return;
}

};

1;
