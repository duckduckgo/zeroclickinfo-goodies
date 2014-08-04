#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

ddg_goodie_test(
	[
		'DDG::Goodie::ToSingular'
	],
	'singular boats' => test_zci('Singular form of boats is boat',
					answer_type => 'tosingular',),
	'Singular sets' => test_zci('Singular form of sets is set',
					answer_type => 'tosingular',),
	'fish single' => test_zci('Singular form of fish is fish',
					answer_type => 'tosingular',),
	'dictionaries single' => test_zci('Singular form of dictionaries is dictionary',
					answer_type => 'tosingular',),
	'single accessories' => test_zci('Singular form of accessories is accessory',
					answer_type => 'tosingular',),
);

done_testing;
