#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'capitalize';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Capitalize
	)],
	'capitalize this' => test_zci('THIS'),
	'uppercase that' => test_zci('THAT'),
);

done_testing;
