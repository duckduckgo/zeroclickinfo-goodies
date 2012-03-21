#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'PercentError';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::PercentError
	)],
	'%err 41 43' => test_zci('Accepted: 41 Experimental: 43 Error: 4.8780487804878%'),
	'percent-error 34.5 35' => test_zci('Accepted: 34.5 Experimental: 35 Error: 1.44927536231884%'),
);

done_testing;

