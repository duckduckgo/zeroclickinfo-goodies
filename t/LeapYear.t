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
	'was 2012 a leap year' => test_zci('2012 CE was a leap year'),
	'will 3012 be a leap year' => test_zci('3012 CE will be a leap year'),
	'was 1 bce a leap year' => test_zci('1 BCE was not a leap year')
);

done_testing;
