#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "poker";
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Poker
	)],
		'poker odds flush' => test_zci('The odds of getting a flush in poker are 508 : 1.', html => 'More at <a href="https://en.wikipedia.org/wiki/List_of_poker_hands#Flush">Wikipedia</a>.'),
		'Probability poker Two Pair' => test_zci('The probability of getting a two pair in poker is 4.75%.', html => 'More at <a href="https://en.wikipedia.org/wiki/List_of_poker_hands#Two_pair">Wikipedia</a>.'),
		'frequency royal flush poker' => test_zci('The frequency of a royal flush in poker is 4 out of 2,598,960.', html => 'More at <a href="https://en.wikipedia.org/wiki/List_of_poker_hands#Royal_flush">Wikipedia</a>.'),
);

done_testing;
