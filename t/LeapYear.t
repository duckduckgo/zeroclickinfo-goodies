#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'leap_year';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::LeapYear
	)],
	'was 2012 a leap year' => test_zci('2012 CE was a leap year'),
	'will 3012 be a leap year' => test_zci('3012 CE will be a leap year'),
	'was 1 bce a leap year' => test_zci('1 BCE was not a leap year'),
	'leap years after 2005' => test_zci('The 5 leap years after 2005 CE are 2008 CE, 2012 CE, 2016 CE, 2020 CE, 2024 CE, 2028 CE'),
	'leap years before 2 bc' => test_zci('The 5 leap years before 2 BCE are 4 BCE, 8 BCE, 12 BCE, 16 BCE, 20 BCE, 24 BCE'),
);

done_testing;
