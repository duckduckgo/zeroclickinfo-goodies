package DDG::Goodie::BirthStone;
#Returns the birthstone of the queried month

#Written by Austin Heimark

use DDG::Goodie;
use Switch;

triggers startend => 'birthstone', 'birth stone';

zci is_cached => 1;

primary_example_queries 'birthstone april';
primary_example_queries 'may birth stone';
description 'returns the birth stone of the specified month';
name 'BirthStone';
topics 'special_interest', 'entertainment';
category 'random';
attribution github => [ 'https://github.com/austinheimark', 'austin_heimark' ];

handle remainder => sub {
	my $stone;
	my $month = lc($_);

	switch ($month)
	{
		case('january') {$stone = "Garnet";}
		case('february') {$stone = "Amethyst";}
		case('march') {$stone = "Aquamarine";}
		case('april') {$stone = "Diamond";}
		case('may') {$stone = "Emerald";}
		case('june') {$stone = "Pearl";}
		case('july') {$stone = "Ruby";}
		case('august') {$stone = "Peridot";}
		case('september') {$stone = "Sapphire";}
		case('october')	{$stone = "Opal";}
		case('november') {$stone = "Topaz";}
		case('december') {$stone = "Turquoise";}
		else {return;}
	}

	return ucfirst($month) . " birthstone: " . $stone;
};

1;
