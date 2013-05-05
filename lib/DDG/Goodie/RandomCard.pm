package DDG::Goodie::RandomCard;
#Returns a random card in a standard deck of 52 cards

#Written by Austin Heimark

use DDG::Goodie;
use Switch;

triggers start => 'random card';

zci is_cached => 1;

primary_example_queries 'random card';
description 'returns a random card in a deck of 52 cards';
name 'RandomCard';
topics 'words_and_games';
category 'random';
attribution github => [ 'https://github.com/austinheimark', 'austin_heimark' ];

handle remainder => sub {
	#if there is text besides 'random card' then the user did not want a random card
	if ($_) {
		return;
	}

	#Generate a random number for the suit and card
	my $rankNumber = int(rand(13));
	my $suitNumber = int(rand(4));

	my $rank;
	my $suit;

	switch ($rankNumber)
	{
		case(0) {$rank = "Two";}
		case(1) {$rank = "Three";}
		case(2) {$rank = "Four";}
		case(3) {$rank = "Five";}
		case(4)	{$rank = "Six";}
		case(5) {$rank = "Seven";}
		case(6) {$rank = "Eight";}
		case(7) {$rank = "Nine";}
		case(8) {$rank = "Ten";}
		case(9)	{$rank = "Jack";}
		case(10) {$rank = "Queen";}
		case(11) {$rank = "King";}
		case(12) {$rank = "Ace";}
	}

	switch ($suitNumber)
	{
		case(0) {$suit = "Spades";}
		case(1) {$suit = "Hearts";}
		case(2) {$suit = "Clubs";}
		case(3) {$suit = "Diamonds";}
	}

	return $rank . " of " . $suit;
};

1;
