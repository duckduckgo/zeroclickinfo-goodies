package DDG::Goodie::ChineseZodiac;
#Returns the chinese zodiac sign of the queried year

use DDG::Goodie;

triggers startend => 'chinese zodiac';

zci answer_type => "chinese_zodiac";
zci is_cached => 1;

primary_example_queries 'chinese zodiac 1972';
description 'returns the chinese zodiac of the queried year';
name 'ChineseZodiac';
topics 'special_interest', 'entertainment';
category 'random';
attribution github => [ 'https://github.com/austinheimark', 'austin_heimark' ];

my %zodiacs = (
	4 => "Rat",
	5 => "Ox",
	6 => "Tiger",
	7 => "Rabbit",
	8 => "Dragon",
	9 => "Snake",
	10 => "Horse",
	11 => "Goat",
	0 => "Monkey",
	1 => "Rooster",
	2 => "Dog",
	3 => "Pig"
);

handle remainder => sub {
	return unless /(\d+)/;
	
	my $link = qq(More at <a href="https://en.wikipedia.org/wiki/Chinese_zodiac">Wikipedia</a>.);
	my $zodiacSign = "The Chinese Zodiac in $1 is the $zodiacs{$1%12}.";
	return $zodiacSign, 'html' => "$zodiacSign $link";
};

1;
