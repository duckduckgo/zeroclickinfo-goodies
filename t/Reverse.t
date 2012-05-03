#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'reverse';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Reverse
	)],
	'reverse bla' => test_zci('Reversed "bla": alb'),
	'reverse blabla' => test_zci('Reversed "blabla": albalb'),
);

done_testing;

