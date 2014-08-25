package DDG::Goodie::BirthStone;
# ABSTRACT: Returns the birthstone of the queried month

use DDG::Goodie;

triggers startend => 'birthstone', 'birth stone';

zci answer_type => "BirthStone";
zci is_cached => 1;

primary_example_queries 'birthstone april';
secondary_example_queries 'may birth stone';
description 'returns the birth stone of the specified month';
name 'BirthStone';
topics 'special_interest', 'entertainment';
category 'random';
attribution github => [ 'https://github.com/austinheimark', 'austin_heimark' ];

my %birthstones = ( 
	"january" => "Garnet",
	"february" => "Amethyst",
	"march" => "Aquamarine",
	"april" => "Diamond",
	"may" => "Emerald",
	"june" => "Pearl",
	"july" => "Ruby",
	"august" => "Peridot",
	"september" => "Sapphire",
	"october" => "Opal",
	"november" => "Topaz",
	"december" => "Turquoise"
);

handle remainder => sub {
	my $month = lc $_;
	my $stone = $birthstones{$month};
	return ucfirst $month . " birthstone: $stone" if $stone;
	return;
};

1;
