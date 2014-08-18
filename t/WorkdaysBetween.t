#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'workdays_between';

ddg_goodie_test(
    [
        'DDG::Goodie::WorkdaysBetween'
    ],

    # Standard work week
    'workdays between 01/06/2014 01/10/2014' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),
    'workdays between 01/06/2014 01/10/2014 inclusive' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),

    # Ending date first
    'workdays between 01/10/2014 01/06/2014'  =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),
    'workdays between 01/10/2014 01/06/2014 inclusive' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),

    # Ending date on a weekend
    'workdays between 01/06/2014 01/12/2014' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 12 Jan 2014."),
    'workdays between 01/06/2014 01/12/2014 inclusive' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 12 Jan 2014."),

    # Including the weekend
    'workdays between 01/06/2014 01/13/2014' =>
        test_zci("There are 6 workdays between 06 Jan 2014 and 13 Jan 2014."),
    'workdays between 01/06/2014 01/13/2014 inclusive' =>
        test_zci("There are 6 workdays between 06 Jan 2014 and 13 Jan 2014."),

    # Including the weekend -- Backwards
    'workdays between 01/13/2014 01/06/2014' =>
        test_zci("There are 6 workdays between 06 Jan 2014 and 13 Jan 2014."),
    'workdays between 01/13/2014 01/06/2014 inclusive' =>
        test_zci("There are 6 workdays between 06 Jan 2014 and 13 Jan 2014."),

    # Starting on a Saturday
    'workdays between 01/11/2014 01/14/2014' =>
        test_zci("There are 2 workdays between 11 Jan 2014 and 14 Jan 2014."),
    'workdays between 01/11/2014 01/14/2014 inclusive' =>
        test_zci("There are 2 workdays between 11 Jan 2014 and 14 Jan 2014."),

    # Starting on a Sunday
    'workdays between 01/12/2014 01/14/2014' =>
        test_zci("There are 2 workdays between 12 Jan 2014 and 14 Jan 2014."),
    'workdays between 01/12/2014 01/14/2014 inclusive' =>
        test_zci("There are 2 workdays between 12 Jan 2014 and 14 Jan 2014."),

    # Workdays in a year
    'workdays between 01/01/2014 01/01/2015' =>
        test_zci("There are 251 workdays between 01 Jan 2014 and 01 Jan 2015."),
    'workdays between 01/01/2014 01/01/2015 inclusive' =>
        test_zci("There are 251 workdays between 01 Jan 2014 and 01 Jan 2015."),

    # Business Days
    'business days between 01/06/2014 01/10/2014' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),
    'business days between 01/06/2014 01/10/2014 inclusive' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),

    # Month and Date are backwards
    'workdays between 16/06/2014 20/06/2014' =>
        test_zci("There are 5 workdays between 16 Jun 2014 and 20 Jun 2014."),
    'workdays between 5/06/2014 20/06/2014' =>
        test_zci("There are 12 workdays between 05 Jun 2014 and 20 Jun 2014."),
    'workdays between 20/06/2014 5/06/2014' =>
        test_zci("There are 12 workdays between 05 Jun 2014 and 20 Jun 2014."),

    # Single digit days and months
    'workdays between 1/6/2014 1/10/2014' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),
    'workdays between 1/6/2014 1/10/2014 inclusive' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),

    # Workdays in a year - Dash format
    'workdays between 01-01-2014 01-01-2015' =>
        test_zci("There are 251 workdays between 01 Jan 2014 and 01 Jan 2015."),
    'workdays between 01-01-2014 01-01-2015 inclusive' =>
        test_zci("There are 251 workdays between 01 Jan 2014 and 01 Jan 2015."),

    # Business Days - Dash format
    'business days between 01-06-2014 01-10-2014' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),
    'business days between 01-06-2014 01-10-2014 inclusive' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),

    # Month and Date are backwards - Dash format
    'workdays between 16-06-2014 20-06-2014' =>
        test_zci("There are 5 workdays between 16 Jun 2014 and 20 Jun 2014."),
    'workdays between 5-06-2014 20-06-2014' =>
        test_zci("There are 12 workdays between 05 Jun 2014 and 20 Jun 2014."),
    'workdays between 20-06-2014 5-06-2014' =>
        test_zci("There are 12 workdays between 05 Jun 2014 and 20 Jun 2014."),

    # Single digit days and months - Dash format
    'workdays between 1-6-2014 1-10-2014' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),
    'workdays between 1-6-2014 1-10-2014 inclusive' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),

    # Unambiguous date format
    'workdays between jan 6 2014 jan 10 2014' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),
    'workdays between jan 6 2014 jan 10 2014 inclusive' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),

    # Unambiguous date format with comma separator
    'workdays between jan 6, 2014 jan 10, 2014' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),
    'workdays between jan 6, 2014 jan 10, 2014 inclusive' =>
        test_zci("There are 5 workdays between 06 Jan 2014 and 10 Jan 2014."),

    # Same day
    'workdays between jan 3, 2014 jan 3, 2014' =>
        test_zci("There is 1 workday between 03 Jan 2014 and 03 Jan 2014."),
    'workdays between jan 3, 2014 jan 3, 2014 inclusive' =>
        test_zci("There is 1 workday between 03 Jan 2014 and 03 Jan 2014."),    

    # Same day on a weekend
    'workdays between jan 4, 2014 jan 4, 2014' =>
        test_zci("There are 0 workdays between 04 Jan 2014 and 04 Jan 2014."),
    'workdays between jan 4, 2014 jan 5, 2014 inclusive' =>
        test_zci("There are 0 workdays between 04 Jan 2014 and 05 Jan 2014."),

    # Weekend in the middle
    'workdays between jan 3, 2014 jan 6, 2014' =>
        test_zci("There are 2 workdays between 03 Jan 2014 and 06 Jan 2014."),
    'workdays between jan 3, 2014 jan 6, 2014 inclusive' =>
        test_zci("There are 2 workdays between 03 Jan 2014 and 06 Jan 2014."),

    # "to"
    'workdays between jan 3, 2014 to jan 6, 2014' =>
        test_zci("There are 2 workdays between 03 Jan 2014 and 06 Jan 2014."),
    'workdays between jan 3, 2014 to jan 6, 2014 inclusive' =>
        test_zci("There are 2 workdays between 03 Jan 2014 and 06 Jan 2014."),

#    # Same day on a weekend - shortened year
#    'workdays between jan 4, 14 jan 4, 2014' =>
#        test_zci("There are 0 workdays between 04 Jan 2014 and 04 Jan 2014."),
#    'workdays between jan 4, 2014 jan 5, 14 inclusive' =>
#        test_zci("There are 0 workdays between 04 Jan 2014 and 05 Jan 2014."),

#    # Weekend in the middle - shortened year
#    'workdays between jan 3, 14 jan 6, 14' =>
#        test_zci("There are 2 workdays between 03 Jan 2014 and 06 Jan 2014."),
#    'workdays between jan 3, 14 jan 6, 14 inclusive' =>
#        test_zci("There are 2 workdays between 03 Jan 2014 and 06 Jan 2014."),

#    # "to" - shortened year
#    'workdays between jan 3, 14 to jan 6, 2014' =>
#        test_zci("There are 2 workdays between 03 Jan 2014 and 06 Jan 2014."),
#    'workdays between jan 3, 14 to jan 6, 2014 inclusive' =>
#        test_zci("There are 2 workdays between 03 Jan 2014 and 06 Jan 2014."),


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
        test_zci("There are 253 workdays between 31 Jan 2000 and 31 Jan 2001."),
    'workdays between 01/31/2000 01/31/2001 inclusive' => 
        test_zci("There are 253 workdays between 31 Jan 2000 and 31 Jan 2001."),
    'workdays between 01/31/2000 and 01/31/2001 inclusive' => 
        test_zci("There are 253 workdays between 31 Jan 2000 and 31 Jan 2001."),
    'workdays between jan 3 2013 and jan 4 2013' => 
        test_zci("There are 2 workdays between 03 Jan 2013 and 04 Jan 2013."),
);

done_testing;
