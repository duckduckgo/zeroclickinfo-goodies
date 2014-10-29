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
	'what is the independence day of norway' => test_zci('Norway assumed independence on May 17, 1814'),
	'independence day, papua new guinea' => test_zci('Papua new guinea assumed independence on September 16, 1975'),
	# question marks
	'what is the independence day of norway?' => test_zci('Norway assumed independence on May 17, 1814'),
	# miscellaneous
	'independence day of papua new guinea' => test_zci('Papua new guinea assumed independence on September 16, 1975'),
	'day of independence of sri lanka' => test_zci('Sri lanka assumed independence on February 4, 1948'),
	'when is the day of independence for norway' => test_zci('Norway assumed independence on May 17, 1814'),
	'day of independence, norway' => test_zci('Norway assumed independence on May 17, 1814'),
	'norway independence day' => test_zci('Norway assumed independence on May 17, 1814'),
	'what day is the independence day of norway' => test_zci('Norway assumed independence on May 17, 1814'),

);

done_testing;
