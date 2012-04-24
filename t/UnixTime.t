#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'time_conversion';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::UnixTime
	)],
	'time 0' => test_zci('Unix Time Conversion: Wed Dec 31 19:00:00 1969'),
	'time 1335233773453' => test_zci('Unix Time Conversion: Mon Apr 23 22:16:13 2012'),
	'time 1335233773' => test_zci('Unix Time Conversion: Mon Apr 23 22:16:13 2012'),
	'time 5325423' => test_zci('Unix Time Conversion: Tue Mar  3 10:17:03 1970'),
	'time 53492399294' => test_zci('Unix Time Conversion: Sat Feb  7 18:48:14 3665')
);

done_testing;
