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
	# miscellaneous
	'independence day of papua new guinea' => test_zci('Papua New Guinea assumed independence on September 16th, 1975', html=>qr/.*/),
	'day of independence of sri lanka' => test_zci('Sri Lanka assumed independence on February 4th, 1948', html=>qr/.*/),
	'when is the day of independence for norway' => test_zci('Norway assumed independence on May 17th, 1814', html=>qr/.*/),
	'day of independence, norway' => test_zci('Norway assumed independence on May 17th, 1814', html=>qr/.*/),
	'norway independence day' => test_zci('Norway assumed independence on May 17th, 1814', html=>qr/.*/),
	'what day is the independence day of norway' => test_zci('Norway assumed independence on May 17th, 1814', html=>qr/.*/),

);

done_testing;
