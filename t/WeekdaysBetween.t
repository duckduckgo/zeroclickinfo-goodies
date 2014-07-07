#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Time::Piece;

zci answer_type => 'weekdays_between';

# In the output, the abbreviated month will return different results based on
# the user's language settings. This means we need to test against those
# specific values instead of hardcoding in the month abbreviations.
# Abbreviation for January (Jan in english)
my $JAN_ABBREV = Time::Piece->strptime("01", "%m")->strftime("%b");
# Abbreviation for June (Jun in english)
my $JUN_ABBREV = Time::Piece->strptime("06", "%m")->strftime("%b");

ddg_goodie_test(
    [
        'DDG::Goodie::WeekdaysBetween'
    ],

    # Test different trigger words
    'week days between 01/06/2014 01/10/2014' =>
        test_zci("There are 5 weekdays between $JAN_ABBREV 06, 2014 and $JAN_ABBREV 10, 2014."),
    'week days from 01/06/2014 01/10/2014' =>
        test_zci("There are 5 weekdays between $JAN_ABBREV 06, 2014 and $JAN_ABBREV 10, 2014."),

    # Standard work week
    'weekdays between 01/06/2014 01/10/2014' =>
        test_zci("There are 5 weekdays between $JAN_ABBREV 06, 2014 and $JAN_ABBREV 10, 2014."),
    
     # Ending date first
    'weekdays between 01/10/2014 01/06/2014'  =>
        test_zci("There are 5 weekdays between $JAN_ABBREV 06, 2014 and $JAN_ABBREV 10, 2014."),

    # Including the weekend -- Backwards
    'weekdays between 01/13/2014 01/06/2014' =>
        test_zci("There are 6 weekdays between $JAN_ABBREV 06, 2014 and $JAN_ABBREV 13, 2014."),

    # Weekdays in a year - Dash format
    'weekdays between 01-01-2014 01-01-2015' =>
        test_zci("There are 262 weekdays between $JAN_ABBREV 01, 2014 and $JAN_ABBREV 01, 2015."),

     # Single digit days and months - Dash format
    'weekdays between 1-6-2014 1-10-2014' =>
        test_zci("There are 5 weekdays between $JAN_ABBREV 06, 2014 and $JAN_ABBREV 10, 2014."),

    # Unambiguous date format
    'weekdays between jan 6 2014 jan 10 2014' =>
        test_zci("There are 5 weekdays between $JAN_ABBREV 06, 2014 and $JAN_ABBREV 10, 2014."),

    # Unambiguous date format with comma separator
    'weekdays between jan 6, 2014 jan 10, 2014' =>
        test_zci("There are 5 weekdays between $JAN_ABBREV 06, 2014 and $JAN_ABBREV 10, 2014."),

    # Weekend in the middle
    'weekdays between jan 3, 2014 jan 6, 2014' =>
        test_zci("There are 2 weekdays between $JAN_ABBREV 03, 2014 and $JAN_ABBREV 06, 2014."),

    # Same day
    'weekdays between jan 3, 2014 jan 3, 2014' =>
        test_zci("There is 1 weekday between $JAN_ABBREV 03, 2014 and $JAN_ABBREV 03, 2014."),
    
    # Same day on a weekend
    'weekdays between jan 4, 2014 jan 4, 2014' =>
        test_zci("There are 0 weekdays between $JAN_ABBREV 04, 2014 and $JAN_ABBREV 04, 2014."),
    
    # Starting on a Saturday
    'weekdays between 01/11/2014 01/14/2014' =>
        test_zci("There are 2 weekdays between $JAN_ABBREV 11, 2014 and $JAN_ABBREV 14, 2014."),

    # Starting on a Sunday
    'weekdays between 01/12/2014 01/17/2014' =>
        test_zci("There are 5 weekdays between $JAN_ABBREV 12, 2014 and $JAN_ABBREV 17, 2014."),

    # Invalid input    
    'weekdays between 01/2013 and 01/2014' => undef,
    'weekdays between feb 30, 2014 to mar 3, 2014' => undef,
    'weekdays between 01/01/2012' => undef,
    'weekdays between 18/17/2013 21/23/2015' => undef,
    'weekdays between 01/2013 and 01/2014 inclusive' => undef,
    'weekdays between feb 30, 2014 mar 3, 2014 inclusive' => undef,
    'weekdays between 01/01/2012 to' => undef,
    'weekdays between 18/17/2013 and 21/23/2015 inclusive' => undef,
);

done_testing;
