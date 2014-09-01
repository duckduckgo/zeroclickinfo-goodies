#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'date_math';
zci is_cached => 1;

my $year = 1900 + ( localtime() )[5];
ddg_goodie_test(
    [qw(
        DDG::Goodie::DateMath
    )],
    'Jan 1 2012 plus 32 days'       => test_zci( '01 Jan 2012 plus 32 days is 02 Feb 2012' ),
    'January 1 2012 plus 32 days'   => test_zci( '01 Jan 2012 plus 32 days is 02 Feb 2012' ),
    'January 1, 2012 plus 32 days'  => test_zci( '01 Jan 2012 plus 32 days is 02 Feb 2012' ),
    'January 1st 2012 plus 32 days' => test_zci( '01 Jan 2012 plus 32 days is 02 Feb 2012' ),
#    'January 1st plus 32 days'      => test_zci( "January 1st $year plus 32 days is 2/2/$year" ),
    '1/1/2012 plus 32 days'         => test_zci( '01 Jan 2012 plus 32 days is 02 Feb 2012' ),
#    '1/1 plus 32 days'              => test_zci( "1/1/$year plus 32 days is 2/2/$year" ),
    '1/1/2012 plus 5 weeks'         => test_zci( '01 Jan 2012 plus 5 weeks is 01 Jan 2012' ),
    '1/1/2012 plus 5 months'        => test_zci( '01 Jan 2012 plus 5 months is 01 Jun 2012' ),
    '1/1/2012 PLUS 5 years'         => test_zci( '01 Jan 2012 plus 5 years is 01 Jan 2017' ),
    '1/1/2012 plus 1 day'           => test_zci( '01 Jan 2012 plus 1 day is 02 Jan 2012' ),
    '1/1/2012 plus 1 days'          => test_zci( '01 Jan 2012 plus 1 day is 02 Jan 2012' ),
    '01/01/2012 + 1 day'            => test_zci( '01 Jan 2012 + 1 day is 02 Jan 2012' ),
    '1/1/2012 minus ten days'       => test_zci( '01 Jan 2012 minus 10 days is 22 Dec 2011' ),
#    'January First plus ten days'   => test_zci( "January 1 $year plus 10 days is 1/11/$year" ),
#    'January first minus ten days' => test_zci('January 1 2014 minus 10 days is 12/22/2013'),
);

done_testing;

