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
	'what is the independence day of norway' => test_zci('Norway assumed independence on May 17th, 1814', html=>qr/.*/),
	'independence day, papua new guinea' => test_zci('Papua New Guinea assumed independence on September 16th, 1975', html=>qr/.*/),
	# question marks
	'what is the independence day of norway?' => test_zci('Norway assumed independence on May 17th, 1814', html=>qr/.*/),
	# some aliases
	'when is the independence day of republic of congo' => test_zci('Republic of the Congo assumed independence on August 15th, 1960', html=>qr/.*/),
	'when is the independence day of republic of the congo' => test_zci('Republic of the Congo assumed independence on August 15th, 1960', html=>qr/.*/),
	'gambia independence day' => test_zci('The Gambia assumed independence on February 18th, 1965', html=>qr/.*/),
	'the gambia independence day' => test_zci('The Gambia assumed independence on February 18th, 1965', html=>qr/.*/),
	'usa independence day' => test_zci('United States of America assumed independence on July 4th, 1776', html=>qr/.*/),
	# data points with two dates
	'independence day of panama' => test_zci('Panama assumed independence on November 28th, 1821 and November 3rd, 1903', html=>qr/.*/),
	'independence day of armenia' => test_zci('Armenia assumed independence on May 28th, 1918 and September 21th, 1991', html=>qr/.*/),
	# miscellaneous
	'independence day of papua new guinea' => test_zci('Papua New Guinea assumed independence on September 16th, 1975', html=>qr/.*/),
	'day of independence of sri lanka' => test_zci('Sri Lanka assumed independence on February 4th, 1948', html=>qr/.*/),
	'when is the day of independence for norway' => test_zci('Norway assumed independence on May 17th, 1814', html=>qr/.*/),
	'day of independence, norway' => test_zci('Norway assumed independence on May 17th, 1814', html=>qr/.*/),
	'norway independence day' => test_zci('Norway assumed independence on May 17th, 1814', html=>qr/.*/),
	'what day is the independence day of norway' => test_zci('Norway assumed independence on May 17th, 1814', html=>qr/.*/),

);

done_testing;
