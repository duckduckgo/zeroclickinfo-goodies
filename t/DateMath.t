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
    'Jan 1 2012 plus 32 days'       => test_zci( '01 Jan 2012 plus 32 days is 02 Feb 2012' ),
    'January 1 2012 plus 32 days'   => test_zci( '01 Jan 2012 plus 32 days is 02 Feb 2012' ),
    'January 1, 2012 plus 32 days'  => test_zci( '01 Jan 2012 plus 32 days is 02 Feb 2012' ),
    'January 1st 2012 plus 32 days' => test_zci( '01 Jan 2012 plus 32 days is 02 Feb 2012' ),
    'January 1st plus 32 days'      => test_zci( qr/01 Jan [0-9]{4} plus 32 days is 02 Feb [0-9]{4}/ ),
    '1/1/2012 plus 32 days'         => test_zci( '01 Jan 2012 plus 32 days is 02 Feb 2012' ),
    '1/1/2012 plus 5 weeks'         => test_zci( '01 Jan 2012 plus 5 weeks is 05 Feb 2012' ),
    '1/1/2012 plus 5 months'        => test_zci( '01 Jan 2012 plus 5 months is 01 Jun 2012' ),
    '1/1/2012 PLUS 5 years'         => test_zci( '01 Jan 2012 plus 5 years is 01 Jan 2017' ),
    '1/1/2012 plus 1 day'           => test_zci( '01 Jan 2012 plus 1 day is 02 Jan 2012' ),
    '1/1/2012 plus 1 days'          => test_zci( '01 Jan 2012 plus 1 day is 02 Jan 2012' ),
    '01/01/2012 + 1 day'            => test_zci( '01 Jan 2012 + 1 day is 02 Jan 2012' ),
    '1/1/2012 minus ten days'       => test_zci( '01 Jan 2012 minus 10 days is 22 Dec 2011' ),
    '1 jan 2014 plus 2 weeks'       => test_zci( '01 Jan 2014 plus 2 weeks is 15 Jan 2014' ),
);

done_testing;

