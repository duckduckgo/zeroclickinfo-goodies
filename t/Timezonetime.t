#!/usr/bin/env perl
# Tests for the Timezonetime goodie

use strict;
use warnings;
use Test::More;
use Test::MockTime qw/:all/;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'timezonetime';
zci is_cached   => 1;

sub build_structured_answer {
    my ($time, $timezone, $daylightSaving) = @_;
    
    return "$time $timezone $daylightSaving",
        structured_answer => {
            data => {
                title    => "$time $timezone",
                subtitle => "$daylightSaving",
            },
            templates => {
                group => 'text',
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

# INFO: Freezes time for below tests.
set_fixed_time('2017-06-03T09:36:53Z');

ddg_goodie_test(
    ['DDG::Goodie::Timezonetime'],
    
    #
    # 1. Queries that SHOULD TRIGGER ~~ IN DAYLIGHT SAVINGS
    #
    'time in pst'  => build_test("02:36:53", "PST", "PST is in daylight saving"),
    'time now cst' => build_test("04:36:53", "CST", "CST is in daylight saving"),
    'time in pst'  => build_test("02:36:53", "PST", "PST is in daylight saving"),
    'time now cst' => build_test("04:36:53", "CST", "CST is in daylight saving"),
    'time in pst'  => build_test("02:36:53", "PST", "PST is in daylight saving"),
    'time now cst' => build_test("04:36:53", "CST", "CST is in daylight saving"),
);

# INFO: Freezes time for below tests.
set_fixed_time('2016-01-03T09:36:53Z');

ddg_goodie_test(
    ['DDG::Goodie::Timezonetime'],
    
    #
    # 2. Queries that SHOULD TRIGGER ~~ NOT IN DAYLIGHT SAVINGS
    #
    'time in pst'  => build_test("01:36:53", "PST", "PST is not in daylight saving"),
    'ist now time' => build_test("15:06:53", "IST", "IST is not in daylight saving"),
    'time now cst' => build_test("03:36:53", "CST", "CST is not in daylight saving"),
    'time in pst'  => build_test("01:36:53", "PST", "PST is not in daylight saving"),
    'ist now time' => build_test("15:06:53", "IST", "IST is not in daylight saving"),
    'time now cst' => build_test("03:36:53", "CST", "CST is not in daylight saving"),
    'time in pst'  => build_test("01:36:53", "PST", "PST is not in daylight saving"),
    
    #
    # 3. Queries that SHOULD NOT TRIGGER
    #
    'what is the time in new york' => undef,
    'do you know what time it is?' => undef,
    'how to tell the time' => undef,
    'time in brooklyn' => undef,
    'time in belfast' => undef,
    'whats the time' => undef,
    'hammer time' => undef,
);

done_testing;
