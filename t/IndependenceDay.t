#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "independence_day";
zci is_cached   => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::IndependenceDay
	)],
	# primary example queries
	'what is the independence day of norway' => test_zci('Independence Day of Norway May 17th, 1814', html=>qr/.*/),
	'independence day, papua new guinea' => test_zci('Independence Day of Papua New Guinea September 16th, 1975', html=>qr/.*/),
	# question marks
	'what is the independence day of norway?' => test_zci('Independence Day of Norway May 17th, 1814', html=>qr/.*/),
	# some aliases
	'when is the independence day of republic of congo' => test_zci('Independence Day of Republic of the Congo August 15th, 1960', html=>qr/.*/),
	'when is the independence day of republic of the congo' => test_zci('Independence Day of Republic of the Congo August 15th, 1960', html=>qr/.*/),
	'gambia independence day' => test_zci('Independence Day of The Gambia February 18th, 1965', html=>qr/.*/),
	'the gambia independence day' => test_zci('Independence Day of The Gambia February 18th, 1965', html=>qr/.*/),
	'usa independence day' => test_zci('Independence Day of United States of America July 4th, 1776', html=>qr/.*/),
	# data points with two dates
	'independence day of panama' => test_zci('Independence Day of Panama November 28th, 1821 and November 3rd, 1903', html=>qr/.*/),
	'independence day of armenia' => test_zci('Independence Day of Armenia May 28th, 1918 and September 21th, 1991', html=>qr/.*/),
	# miscellaneous
	'independence day of papua new guinea' => test_zci('Independence Day of Papua New Guinea September 16th, 1975', html=>qr/.*/),
	'day of independence of sri lanka' => test_zci('Independence Day of Sri Lanka February 4th, 1948', html=>qr/.*/),
	'when is the day of independence for norway' => test_zci('Independence Day of Norway May 17th, 1814', html=>qr/.*/),
	'day of independence, norway' => test_zci('Independence Day of Norway May 17th, 1814', html=>qr/.*/),
	'norway independence day' => test_zci('Independence Day of Norway May 17th, 1814', html=>qr/.*/),
	'what day is the independence day of norway' => test_zci('Independence Day of Norway May 17th, 1814', html=>qr/.*/),

);

done_testing;
