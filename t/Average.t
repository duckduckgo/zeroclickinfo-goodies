#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'average';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Average
	)],
	'1 2 3 avg' => test_zci(qr/Mean: 2\s+Median: 2\s+Root Mean Square: 2.16024689946929/),
	'mean 1, 2, 3' => test_zci(qr/Mean: 2\s+Median: 2\s+Root Mean Square: 2.16024689946929/),
	'root mean square 1,2,3' => test_zci(qr/Mean: 2\s+Median: 2\s+Root Mean Square: 2.16024689946929/),
);

done_testing;

