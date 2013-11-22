#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "chinese_zodiac";
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::ChineseZodiac
	)],
		'chinese zodiac 1994' => test_zci('The Chinese Zodiac in 1994 is the Dog.', html => 'The Chinese Zodiac in 1994 is the Dog. More at <a href="https://en.wikipedia.org/wiki/Chinese_zodiac">Wikipedia</a>.'),
		'1888 Chinese Zodiac' => test_zci ('The Chinese Zodiac in 1888 is the Rat.', html => 'The Chinese Zodiac in 1888 is the Rat. More at <a href="https://en.wikipedia.org/wiki/Chinese_zodiac">Wikipedia</a>.'),
);

done_testing;
