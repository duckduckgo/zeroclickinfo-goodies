#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "factors";
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Factors
	)],
		'30 factors' => test_zci('Factors of 30: 1 2 3 5 6 10 15 30'),
		'factors of 72' => test_zci('Factors of 72: 1 2 3 4 6 8 9 12 18 24 36 72'),
);

done_testing;
