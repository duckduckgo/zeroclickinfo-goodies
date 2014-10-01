#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "twelve_oclock";
zci is_cached   => 1;

ddg_goodie_test([qw(
          DDG::Goodie::TwelveOclock
          )
    ],
    'is 1200a.m. noon'               => test_zci('No, 12:00am is midnight.'),
    'is 1200pm noon?'                => test_zci('Yes, 12:00pm is noon.'),
    'is 12:00 am midnight'           => test_zci('Yes, 12:00am is midnight.'),
    'is 12:00 pm midnight?'          => test_zci('No, 12:00pm is noon.'),
    'is 12:00 p.m. midnight?'        => test_zci('No, 12:00pm is noon.'),
    'is 12:00 AM midnight?'          => test_zci('Yes, 12:00am is midnight.'),
    'noon is 12:00 p.m.'             => test_zci('Yes, 12:00pm is noon.'),
    'midnight is 12 AM'              => test_zci('Yes, 12:00am is midnight.'),
    'is 12:00P.M. midnight or noon?' => test_zci('12:00pm is noon.'),
    'is 12am noon or midnight'       => test_zci('12:00am is midnight.'),
    'when is midnight'               => test_zci('12:00am is midnight.'),
    'when is noon?'                  => test_zci('12:00pm is noon.'),
    'threat level midnight'          => undef,
    '12 midnight'                    => undef,
    'midnight movies'                => undef,
    'when is the midnight showing?'  => undef,
    'when is noon in Jakarta?'       => undef,
);

done_testing;
