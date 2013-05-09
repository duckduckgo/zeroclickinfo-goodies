package DDG::Goodie::Poker;
#Returns requested statistic for the requested poker hand

use DDG::Goodie;

triggers any => 'poker';

zci answer_type => "poker";
zci is_cached => 1;

primary_example_queries 'poker odds three of a kind';
secondary_example_queries 'probability poker flush';
description 'returns requested statistic of the requested poker hand';
name 'Poker';
topics 'gaming', 'entertainment';
category 'random';
attribution github => [ 'https://github.com/austinheimark', 'austin_heimark' ];

my %odds = (
	"royal flush" => "649,739",
	"straight flush" => "72,192",
	"four of a kind" => "4,164",
	"full house" => "693",
	"flush" => "508",
	"straight" => "254",
	"three of a kind" => "46.3",
	"two pair" => "20.0",
	"one pair" => "1.36",
	"no pair" => "0.995",
	"high card" => "0.995",
);

my %frequency = (
	"royal flush" => "4",
	"straight flush" => "36",
	"four of a kind" => "624",
	"full house" => "3,744",
	"flush" => "5,108",
	"straight" => "10,200",
	"three of a kind" => "54,912",
	"two pair" => "123,552",
	"one pair" => "1,098,240",
	"no pair" => "1,302,540",
	"high card" => "1,302,540",
);

my %probability = (
	"royal flush" => "0.000154",
	"straight flush" => "0.00139",
	"four of a kind" => "0.0240",
	"full house" => "0.144",
	"flush" => "0.197",
	"straight" => "0.392",
	"three of a kind" => "2.11",
	"two pair" => "4.75",
	"one pair" => "42.3",
	"no pair" => "50.1",
	"high card" => "50.1",
);

handle remainder => sub {
	#make sure the reuqested hand is listed
	return unless /^(frequency|probability|odds)\s(.+)$/i && ($odds{lc($2)});

	return "The odds of getting a $2 in poker are $odds{lc($2)} : 1." if lc($1) eq 'odds';
	return "The frequency of a $2 in poker is $frequency{lc($2)} out of 2,598,960." if lc($1) eq 'frequency';
	return "The probability of getting a $2 in poker is $probability{lc($2)}%." if lc($1) eq 'probability';

	return;
};

1;
