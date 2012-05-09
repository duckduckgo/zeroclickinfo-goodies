#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'date_math';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::DateMath
	)],
	'1/1/2012 plus 32 days'  => test_zci( '1/1/2012 plus 32 days is 2/2/2012' ),
	'1/1 plus 32 days'       => test_zci( '1/1/2012 plus 32 days is 2/2/2012' ),
	'1/1/2012 plus 5 weeks'  => test_zci( '1/1/2012 plus 5 weeks is 2/5/2012' ),
	'1/1/2012 plus 5 months' => test_zci( '1/1/2012 plus 5 months is 6/1/2012' ),
	'1/1/2012 PLUS 5 years'  => test_zci( '1/1/2012 plus 5 years is 1/1/2017' ),
	'1/1/2012 plus 1 day'    => test_zci( '1/1/2012 plus 1 day is 1/2/2012' ),
	'1/1/2012 plus 1 days'   => test_zci( '1/1/2012 plus 1 day is 1/2/2012' ),
	'1/1/2012 + 1 day'       => test_zci( '1/1/2012 + 1 day is 1/2/2012' ),
	'1/1/2012 minus 10 days' => test_zci( '1/1/2012 minus 10 days is 12/22/2011' ),
);

done_testing;

