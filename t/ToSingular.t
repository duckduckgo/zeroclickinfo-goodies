#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

ddg_goodie_test(
	[
		'DDG::Goodie::ToSingular'
	],
	'singular boats' => undef,
	'single mom' => undef,
	'singular form of computers' => test_zci('The singular form of computers is computer', answer_type => 'tosingular'),
	'fish singular form' => test_zci('The singular form of fish is fish', answer_type => 'tosingular'),
	'plural to singular thunderstorms' => test_zci('The singular form of thunderstorms is thunderstorm', answer_type => 'tosingular'),
);

done_testing;
