#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'leap_year';

ddg_goodie_test(
	[qw(
		DDG::Goodie::LeapYear
	)],
	'is 2012 a leap year' => test_zci('2012 CE is a leap year'),
	'will 2013 be a leap year' => test_zci('2013 CE is not a leap year'),
);

done_testing;
