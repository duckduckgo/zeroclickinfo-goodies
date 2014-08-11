#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Time::Piece;

zci answer_type => 'workdays_between';

# In the output, the abbreviated month will return different results based on
# the user's language settings. This means we need to test against those
# specific values instead of hardcoding in the month abbreviations.
# Abbreviation for January (Jan in english)
my $JAN_ABBREV = Time::Piece->strptime("01", "%m")->strftime("%b");
# Abbreviation for June (Jun in english)
my $JUN_ABBREV = Time::Piece->strptime("06", "%m")->strftime("%b");

ddg_goodie_test(
    [
        'DDG::Goodie::WorkdaysBetween'
    ],

    # Standard work week
    'workdays between 01/06/2014 01/10/2014' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),
    'workdays between 01/06/2014 01/10/2014 inclusive' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),

    # Ending date first
    'workdays between 01/10/2014 01/06/2014'  =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),
    'workdays between 01/10/2014 01/06/2014 inclusive' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),

    # Ending date on a weekend
    'workdays between 01/06/2014 01/12/2014' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 12 $JAN_ABBREV 2014."),
    'workdays between 01/06/2014 01/12/2014 inclusive' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 12 $JAN_ABBREV 2014."),

    # Including the weekend
    'workdays between 01/06/2014 01/13/2014' =>
        test_zci("There are 6 workdays between 06 $JAN_ABBREV 2014 and 13 $JAN_ABBREV 2014."),
    'workdays between 01/06/2014 01/13/2014 inclusive' =>
        test_zci("There are 6 workdays between 06 $JAN_ABBREV 2014 and 13 $JAN_ABBREV 2014."),

    # Including the weekend -- Backwards
    'workdays between 01/13/2014 01/06/2014' =>
        test_zci("There are 6 workdays between 06 $JAN_ABBREV 2014 and 13 $JAN_ABBREV 2014."),
    'workdays between 01/13/2014 01/06/2014 inclusive' =>
        test_zci("There are 6 workdays between 06 $JAN_ABBREV 2014 and 13 $JAN_ABBREV 2014."),

    # Starting on a Saturday
    'workdays between 01/11/2014 01/14/2014' =>
        test_zci("There are 2 workdays between 11 $JAN_ABBREV 2014 and 14 $JAN_ABBREV 2014."),
    'workdays between 01/11/2014 01/14/2014 inclusive' =>
        test_zci("There are 2 workdays between 11 $JAN_ABBREV 2014 and 14 $JAN_ABBREV 2014."),

    # Starting on a Sunday
    'workdays between 01/12/2014 01/14/2014' =>
        test_zci("There are 2 workdays between 12 $JAN_ABBREV 2014 and 14 $JAN_ABBREV 2014."),
    'workdays between 01/12/2014 01/14/2014 inclusive' =>
        test_zci("There are 2 workdays between 12 $JAN_ABBREV 2014 and 14 $JAN_ABBREV 2014."),

    # Workdays in a year
    'workdays between 01/01/2014 01/01/2015' =>
        test_zci("There are 251 workdays between 01 $JAN_ABBREV 2014 and 01 $JAN_ABBREV 2015."),
    'workdays between 01/01/2014 01/01/2015 inclusive' =>
        test_zci("There are 251 workdays between 01 $JAN_ABBREV 2014 and 01 $JAN_ABBREV 2015."),

    # Business Days
    'business days between 01/06/2014 01/10/2014' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),
    'business days between 01/06/2014 01/10/2014 inclusive' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),

    # Month and Date are backwards
    'workdays between 16/06/2014 20/06/2014' =>
        test_zci("There are 5 workdays between 16 $JUN_ABBREV 2014 and 20 $JUN_ABBREV 2014."),
    'workdays between 5/06/2014 20/06/2014' =>
        test_zci("There are 12 workdays between 05 $JUN_ABBREV 2014 and 20 $JUN_ABBREV 2014."),
    'workdays between 20/06/2014 5/06/2014' =>
        test_zci("There are 12 workdays between 05 $JUN_ABBREV 2014 and 20 $JUN_ABBREV 2014."),

    # Single digit days and months
    'workdays between 1/6/2014 1/10/2014' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),
    'workdays between 1/6/2014 1/10/2014 inclusive' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),

    # Workdays in a year - Dash format
    'workdays between 01-01-2014 01-01-2015' =>
        test_zci("There are 251 workdays between 01 $JAN_ABBREV 2014 and 01 $JAN_ABBREV 2015."),
    'workdays between 01-01-2014 01-01-2015 inclusive' =>
        test_zci("There are 251 workdays between 01 $JAN_ABBREV 2014 and 01 $JAN_ABBREV 2015."),

    # Business Days - Dash format
    'business days between 01-06-2014 01-10-2014' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),
    'business days between 01-06-2014 01-10-2014 inclusive' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),

    # Month and Date are backwards - Dash format
    'workdays between 16-06-2014 20-06-2014' =>
        test_zci("There are 5 workdays between 16 $JUN_ABBREV 2014 and 20 $JUN_ABBREV 2014."),
    'workdays between 5-06-2014 20-06-2014' =>
        test_zci("There are 12 workdays between 05 $JUN_ABBREV 2014 and 20 $JUN_ABBREV 2014."),
    'workdays between 20-06-2014 5-06-2014' =>
        test_zci("There are 12 workdays between 05 $JUN_ABBREV 2014 and 20 $JUN_ABBREV 2014."),

    # Single digit days and months - Dash format
    'workdays between 1-6-2014 1-10-2014' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),
    'workdays between 1-6-2014 1-10-2014 inclusive' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),

    # Unambiguous date format
    'workdays between jan 6 2014 jan 10 2014' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),
    'workdays between jan 6 2014 jan 10 2014 inclusive' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),

    # Unambiguous date format with comma separator
    'workdays between jan 6, 2014 jan 10, 2014' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),
    'workdays between jan 6, 2014 jan 10, 2014 inclusive' =>
        test_zci("There are 5 workdays between 06 $JAN_ABBREV 2014 and 10 $JAN_ABBREV 2014."),

    # Same day
    'workdays between jan 3, 2014 jan 3, 2014' =>
        test_zci("There is 1 workday between 03 $JAN_ABBREV 2014 and 03 $JAN_ABBREV 2014."),
    'workdays between jan 3, 2014 jan 3, 2014 inclusive' =>
        test_zci("There is 1 workday between 03 $JAN_ABBREV 2014 and 03 $JAN_ABBREV 2014."),    

    # Same day on a weekend
    'workdays between jan 4, 2014 jan 4, 2014' =>
        test_zci("There are 0 workdays between 04 $JAN_ABBREV 2014 and 04 $JAN_ABBREV 2014."),
    'workdays between jan 4, 2014 jan 5, 2014 inclusive' =>
        test_zci("There are 0 workdays between 04 $JAN_ABBREV 2014 and 05 $JAN_ABBREV 2014."),

    # Weekend in the middle
    'workdays between jan 3, 2014 jan 6, 2014' =>
        test_zci("There are 2 workdays between 03 $JAN_ABBREV 2014 and 06 $JAN_ABBREV 2014."),
    'workdays between jan 3, 2014 jan 6, 2014 inclusive' =>
        test_zci("There are 2 workdays between 03 $JAN_ABBREV 2014 and 06 $JAN_ABBREV 2014."),

    # "to"
    'workdays between jan 3, 2014 to jan 6, 2014' =>
        test_zci("There are 2 workdays between 03 $JAN_ABBREV 2014 and 06 $JAN_ABBREV 2014."),
    'workdays between jan 3, 2014 to jan 6, 2014 inclusive' =>
        test_zci("There are 2 workdays between 03 $JAN_ABBREV 2014 and 06 $JAN_ABBREV 2014."),

#    # Same day on a weekend - shortened year
#    'workdays between jan 4, 14 jan 4, 2014' =>
#        test_zci("There are 0 workdays between 04 $JAN_ABBREV 2014 and 04 $JAN_ABBREV 2014."),
#    'workdays between jan 4, 2014 jan 5, 14 inclusive' =>
#        test_zci("There are 0 workdays between 04 $JAN_ABBREV 2014 and 05 $JAN_ABBREV 2014."),

#    # Weekend in the middle - shortened year
#    'workdays between jan 3, 14 jan 6, 14' =>
#        test_zci("There are 2 workdays between 03 $JAN_ABBREV 2014 and 06 $JAN_ABBREV 2014."),
#    'workdays between jan 3, 14 jan 6, 14 inclusive' =>
#        test_zci("There are 2 workdays between 03 $JAN_ABBREV 2014 and 06 $JAN_ABBREV 2014."),

#    # "to" - shortened year
#    'workdays between jan 3, 14 to jan 6, 2014' =>
#        test_zci("There are 2 workdays between 03 $JAN_ABBREV 2014 and 06 $JAN_ABBREV 2014."),
#    'workdays between jan 3, 14 to jan 6, 2014 inclusive' =>
#        test_zci("There are 2 workdays between 03 $JAN_ABBREV 2014 and 06 $JAN_ABBREV 2014."),


    # Invalid input
    'workdays between 01/2014 01/2015' => undef,
    'workdays between 01/2014/01' => undef,
    'workdays between 01/01/2014 inclusive' => undef,
    'workdays between 01/01/2014' => undef,
    'workdays between 20/01/2014 inclusive' => undef,
    'workdays between 19/19/2014 20/24/2015' => undef,
    'workdays between 19/19/2014 20/24/2015 inclusive' => undef,
    'workdays from FEB 30 2014 to March 24 2014' => undef,

    'workdays between 01/31/2000 01/31/2001' => 
        test_zci("There are 253 workdays between 31 $JAN_ABBREV 2000 and 31 $JAN_ABBREV 2001."),
    'workdays between 01/31/2000 01/31/2001 inclusive' => 
        test_zci("There are 253 workdays between 31 $JAN_ABBREV 2000 and 31 $JAN_ABBREV 2001."),
);

done_testing;
