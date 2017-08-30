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

# Time fixed at the end of a day for UTC, hence we can observe that some
# timezones are a day after.
set_fixed_time('2015-06-16T23:59:14Z');

ddg_goodie_test(
    ['DDG::Goodie::Timezonetime'],
    
    'time in cest' => build_test([{ name => "Central European Summer Time",
                                    offset => "+2:00",
                                    time => "01:59:14",
                                    day => 17,
                                    dayName => "Wednesday",
                                    monthName => "June",
                                    year => 2015 }],
                                 "CEST"),
    'time now ist' => build_test([{ name => "India Standard Time",
                                    offset => "+5:30",
                                    time => "05:29:14",
                                    day => 17,
                                    dayName => "Wednesday",
                                    monthName => "June",
                                    year => 2015},
                                  { name => "Irish Standard Time",
                                    offset => "+1:00",
                                    time => "00:59:14",
                                    day => 17,
                                    dayName => "Wednesday",
                                    monthName => "June",
                                    year => 2015 },
                                  { name => "Israel Standard Time",
                                    offset => "+2:00",
                                    time => "01:59:14",
                                    day => 17,
                                    dayName => "Wednesday",
                                    monthName => "June",
                                    year => 2015 }],
                                 "IST")
);

# Time is fixed at the beginning of a day for UTC, hence we can observe
# that some timezones are a day before.
set_fixed_time('2015-06-16T00:30:12Z');

ddg_goodie_test(
   ['DDG::Goodie::Timezonetime'],
   
   'time in gft' => build_test([{ name => "French Guiana Time",
                                  offset => "-3:00",
                                  time => "21:30:12",
                                  day => 15,
                                  dayName => "Monday",
                                  monthName => "June",
                                  year => 2015 }],
                               "GFT"),
   'time now hadt' => build_test([{ name => "Hawaii-Aleutian Daylight Time",
                                    offset => "-9:00",
                                    time => "15:30:12",
                                    day => 15,
                                    dayName => "Monday",
                                    monthName => "June",
                                    year => 2015 }],
                                 "HADT")
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
