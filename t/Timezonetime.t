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
    my ($times, $timezone) = @_;
    
    return "times in $timezone",
        structured_answer => {
            meta => {
                sourceName => 'timeanddate',
                sourceUrl => 'https://www.timeanddate.com/time/zones/'
            },
            data => {
                title => "Timezone $timezone",
                list => $times
            },
            templates => {
                group => 'list',
                options => {
                    list_content => 'DDH.timezonetime.content'
                }
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

# INFO: Freezes time for below tests.
set_fixed_time('2017-06-03T09:36:53Z');

ddg_goodie_test(
    ['DDG::Goodie::Timezonetime'],
    
    'time in cet'  => build_test([{ name => "Central European Time",
                                    offset => "+1:00",
                                    time => "10:36:53",
                                    day => 3,
                                    dayName => "Saturday",
                                    monthName => "June",
                                    year => 2017 }], 
                                 "CET"),
    'time now cst' => build_test([{ name => "Central Standard Time",
                                    offset => "-6:00",
                                    time => "03:36:53",
                                    day => 3,
                                    dayName => "Saturday",
                                    monthName => "June",
                                    year => 2017 },
                                  { name => "China Standard Time",
                                    offset => "+8:00",
                                    time => "17:36:53",
                                    day => 3,
                                    dayName => "Saturday",
                                    monthName => "June",
                                    year => 2017 },
                                  { name => "Cuba Standard Time",
                                    offset => "-5:00",
                                    time => "04:36:53",
                                    day => 3,
                                    dayName => "Saturday",
                                    monthName => "June",
                                    year => 2017 }],
                                 "CST"),
    'time in pst'  => build_test([{ name => "Pacific Standard Time",
                                    offset => "-8:00",
                                    time => "01:36:53",
                                    day => 3,
                                    dayName => "Saturday",
                                    monthName => "June",
                                    year => 2017 },
                                  { name => "Pitcairn Standard Time",
                                    offset => "-8:00",
                                    time => "01:36:53",
                                    day => 3,
                                    dayName => "Saturday",
                                    monthName => "June",
                                    year => 2017 }],
                                 "PST"),
    'time now cst' => build_test([{ name => "Central Standard Time",
                                    offset => "-6:00",
                                    time => "03:36:53",
                                    day => 3,
                                    dayName => "Saturday",
                                    monthName => "June",
                                    year => 2017 },
                                  { name => "China Standard Time",
                                    offset => "+8:00",
                                    time => "17:36:53",
                                    day => 3,
                                    dayName => "Saturday",
                                    monthName => "June",
                                    year => 2017 },
                                  { name => "Cuba Standard Time",
                                    offset => "-5:00",
                                    time => "04:36:53",
                                    day => 3,
                                    dayName => "Saturday",
                                    monthName => "June",
                                    year => 2017 }],
                                 "CST")
);

# INFO: Freezes time for below tests.
set_fixed_time('2016-01-03T09:36:53Z');

ddg_goodie_test(
    ['DDG::Goodie::Timezonetime'],
    #
    # Queries that SHOULD NOT TRIGGER
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
