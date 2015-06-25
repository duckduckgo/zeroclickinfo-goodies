#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "uptime";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Uptime )],

    # A complete text+html positive test
    'uptime 99%' => test_zci(qr/^Implied downtimes for 99% uptime.*/, html=>qr/.*/),
    'uptime 99%' => test_zci(qr/.*Daily: 14 minutes and 24 seconds.*/, html=>qr/.*/),
    'uptime 99%' => test_zci(qr/.*Monthly: 7 hours and 18 minutes.*/, html=>qr/.*/),
    'uptime 99%' => test_zci(qr/.*Annually: 3 days and 16 hours$/, html=>qr/.*/),
    'uptime 99%' => test_zci(qr/.*/, html=>qr/.*99% uptime.*/),
    'uptime 99%' => test_zci(qr/.*/, html=>qr/.*Implied downtimes for 99% uptime.*/),
    'uptime 99%' => test_zci(qr/.*/, html=>qr/.*Daily: 14 minutes and 24 seconds.*/),
    'uptime 99%' => test_zci(qr/.*/, html=>qr/.*Monthly: 7 hours and 18 minutes.*/),
    'uptime 99%' => test_zci(qr/.*/, html=>qr/.*Annually: 3 days and 16 hours.*/),

    # Alternate trigger
    'uptime of 99%' => test_zci(qr/^Implied downtimes for 99% uptime.*/, html=>qr/.*/),
    
    # Startend trigger
    '99% uptime' => test_zci(qr/^Implied downtimes for 99% uptime.*/, html=>qr/.*/),

    # Decimal separator
    'uptime 99,99%' => test_zci(qr/.*/, html=>qr/.*99,99% uptime.*/),
    'uptime 99.99%' => test_zci(qr/.*/, html=>qr/.*99.99% uptime.*/),
    
    # Grouping allowed on input
    'uptime 99.999 999 999%' => test_zci(qr/.*/, html=>qr/.*99.999999999% uptime.*/),

    # Less than 100% uptime but close to no downtime
    'uptime 99.999999999%' => test_zci(qr/.*/, html=>qr/.*No downtime or less than a second during a year.*/),

    # Some parts (but not all) are below 1 second
    'uptime 99.9999%' => test_zci(qr/.*/, html=>qr/.*Annually: 31 seconds.*/),
    'uptime 99.9999%' => test_zci(qr/.*/, html=>qr/.*Monthly: 2 seconds.*/),
    'uptime 99.9999%' => test_zci(qr/.*/, html=>qr/.*Daily: less than one second.*/),
    'uptime 99.99999%' => test_zci(qr/.*/, html=>qr/.*Annually: 3 seconds.*/),
    'uptime 99.99999%' => test_zci(qr/.*/, html=>qr/.*Monthly: less than one second.*/),
    'uptime 99.99999%' => test_zci(qr/.*/, html=>qr/.*Daily: less than one second.*/),

    # Lower limit
    'uptime 0%' => test_zci(qr/.*/, html=>qr/.*0% uptime.*/),
    'uptime 000%' => test_zci(qr/.*/, html=>qr/.*000% uptime.*/),

    # Outside range
    'uptime 101%' => undef,
    'uptime 100.00000000000000000000000000001%' => undef,
    'uptime -10%' => undef,
    'uptime -0.00000000000000000000000000001%' => undef,

    # Upper limit 100% is not allowed as it would return a tautology
    'uptime 100%' => undef,
    'uptime 100.00%' => undef,

    # Misc bad queries
    'uptime 99.99.99%' => undef,
    'uptime 99.99' => undef,
    'uptime ninety-nine' => undef,
    'up time 99%' => undef,
    'up time 99%%' => undef
);

done_testing;
