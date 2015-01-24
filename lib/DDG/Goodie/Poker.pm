package DDG::Goodie::Poker;
# ABSTRACT: Returns requested statistic for the requested poker hand

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
attribution github => [ 'austinheimark', 'Austin Heimark' ];

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

my %webaddresses = (
	"royal flush" => "Royal_flush",
	"straight flush" => "Straight_flush",
	"four of a kind" => "Four_of_a_kind",
	"full house" => "Full_house",
	"flush" => "Flush",
	"straight" => "Straight",
	"three of a kind" => "Three_of_a_kind",
	"two pair" => "Two_pair",
	"one pair" => "One_pair",
	"no pair" => "High_card",
	"high card" => "High_card",
);

handle remainder => sub {
	#make sure the requested hand is listed
	return unless /^(frequency|probability|odds)\s(.+)$/i && ($odds{lc$2});

    my $query = lc $1;
	my $hand  = lc $2;

    my $odds = "The odds of getting a $hand in poker are $odds{$hand} : 1.";
    my $freq = "The frequency of a $hand in poker is $frequency{$hand} out of 2,598,960.";
    my $prob = "The probability of getting a $hand in poker is $probability{$hand}%.";

    my $link = qq(More at <a href="https://en.wikipedia.org/wiki/List_of_poker_hands#$webaddresses{$hand}">Wikipedia</a>.);

    my %answer = (
        'odds'        => [$odds, 'html' => "$odds $link"],
        'frequency'   => [$freq, 'html' => "$freq $link"],
        'probability' => [$prob, 'html' => "$prob $link"],
    );

    return @{$answer{$query}} if exists $answer{$query};

	return;
};

1;
