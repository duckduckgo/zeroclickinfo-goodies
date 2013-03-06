#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Date::Hijri;

zci answer_type => 'date';
zci is_cached => 0;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Hijri
	)],
	'22/8/2003 on the gregorian calendar is on the hijri calendar' => test_zci('23/6/1424'),
	'23/6/1424 in hijri time is in gregorian time' => test_zci('22/8/2003'),
	'22,8,2003 in gregorian date is in hijri date' => test_zci('23/6/1424'),
);

done_testing;
