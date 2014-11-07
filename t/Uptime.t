#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "uptime";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Uptime )],

    # Remark: tests primarily focus on the html part.
    
    # A complete text+html positive test
    'uptime 99%' => test_zci(qr/^Uptime of 99%.*/, html=>qr/.*/),
    'uptime 99%' => test_zci(qr/.*14 minutes and 24 seconds downtime per day.*/, html=>qr/.*/),
    'uptime 99%' => test_zci(qr/.*7 hours and 18 minutes downtime per month.*/, html=>qr/.*/),
    'uptime 99%' => test_zci(qr/.*3 days and 16 hours downtime per year.*/, html=>qr/.*/),
    'uptime 99%' => test_zci(qr/.*/, html=>qr/.*Uptime of 99%.*/),
    'uptime 99%' => test_zci(qr/.*/, html=>qr/.*14 minutes and 24 seconds downtime per day.*/),
    'uptime 99%' => test_zci(qr/.*/, html=>qr/.*7 hours and 18 minutes downtime per month.*/),
    'uptime 99%' => test_zci(qr/.*/, html=>qr/.*3 days and 16 hours downtime per year.*/),

    # Alternate trigger
    'uptime of 99%' => test_zci(qr/^Uptime of 99%.*/, html=>qr/.*/),
    
    # Decimal separator
    'uptime 99,99%' => test_zci(qr/.*/, html=>qr/.*Uptime of 99,99%.*/),
    'uptime 99.99%' => test_zci(qr/.*/, html=>qr/.*Uptime of 99.99%.*/),
    
    # Grouping allowed on input
    'uptime 99.999 999 999%' => test_zci(qr/.*/, html=>qr/.*Uptime of 99.999999999%.*/),

    # Less than 100% uptime but close to no downtime
    'uptime 99.999999999%' => test_zci(qr/.*/, html=>qr/.*No downtime or less than a second during a year.*/),

    # Some parts (but not all) are below 1 second
    'uptime 99.9999%' => test_zci(qr/.*/, html=>qr/.*31 seconds downtime per year.*/),
    'uptime 99.9999%' => test_zci(qr/.*/, html=>qr/.*2 seconds downtime per month.*/),
    'uptime 99.9999%' => test_zci(qr/.*/, html=>qr/.*Less than one second downtime per day.*/),
    'uptime 99.99999%' => test_zci(qr/.*/, html=>qr/.*3 seconds downtime per year.*/),
    'uptime 99.99999%' => test_zci(qr/.*/, html=>qr/.*Less than one second downtime per month.*/),
    'uptime 99.99999%' => test_zci(qr/.*/, html=>qr/.*Less than one second downtime per day.*/),

    # Lower limit
    'uptime 0%' => test_zci(qr/.*/, html=>qr/.*Uptime of 0%.*/),
    'uptime 000%' => test_zci(qr/.*/, html=>qr/.*Uptime of 000%.*/),

    # Outside range
    'uptime 101%' => undef,
    'uptime 100.00000000000000000000000000001%' => undef,
    'uptime -10%' => undef,
    'uptime -0.00000000000000000000000000001%' => undef,

    # Upper limit 100% is not allowed as it would return a tautology
    'uptime 100%' => undef,
    'uptime 100.00%' => undef,

    # Misc bad queries
    'uptime 99.99' => undef,
    'uptime ninety-nine' => undef,
    'up time 99%' => undef
);

done_testing;
