#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'weekdays_between';

ddg_goodie_test(
    [
        'DDG::Goodie::WeekdaysBetween'
    ],

    # Primary query example
    'weekdays between 01/31/2000 01/31/2001' =>
	test_zci("There are 263 weekdays between 31 Jan 2000 and 31 Jan 2001.", html => qr/.*/),

    # Test different trigger words
    'week days between 01/06/2014 01/10/2014' =>
        test_zci("There are 5 weekdays between 06 Jan 2014 and 10 Jan 2014.", html => qr/.*/),
    'week days from 01/06/2014 01/10/2014' =>
        test_zci("There are 5 weekdays between 06 Jan 2014 and 10 Jan 2014.", html => qr/.*/),
    'weekdays from 01/06/2014 01/10/2014' =>
        test_zci("There are 5 weekdays between 06 Jan 2014 and 10 Jan 2014.", html => qr/.*/),


    # Standard work week
    'weekdays between 01/06/2014 01/10/2014' =>
        test_zci("There are 5 weekdays between 06 Jan 2014 and 10 Jan 2014.", html => qr/.*/),
    
     # Ending date first
    'weekdays between 01/10/2014 01/06/2014'  =>
        test_zci("There are 5 weekdays between 06 Jan 2014 and 10 Jan 2014.", html => qr/.*/),

    # Including the weekend -- Backwards
    'weekdays between 01/13/2014 01/06/2014' =>
        test_zci("There are 6 weekdays between 06 Jan 2014 and 13 Jan 2014.", html => qr/.*/),

    # Weekdays in a year - Dash format
    'weekdays between 01-01-2014 01-01-2015' =>
        test_zci("There are 262 weekdays between 01 Jan 2014 and 01 Jan 2015.", html => qr/.*/),

     # Single digit days and months - Dash format
    'weekdays between 1-6-2014 1-10-2014' =>
        test_zci("There are 5 weekdays between 06 Jan 2014 and 10 Jan 2014.", html => qr/.*/),

    # Unambiguous date format
    'weekdays between jan 6 2014 jan 10 2014' =>
        test_zci("There are 5 weekdays between 06 Jan 2014 and 10 Jan 2014.", html => qr/.*/),

    # Unambiguous date format with comma separator
    'weekdays between jan 6, 2014 jan 10, 2014' =>
        test_zci("There are 5 weekdays between 06 Jan 2014 and 10 Jan 2014.", html => qr/.*/),

    # Weekend in the middle
    'weekdays between jan 3, 2014 jan 6, 2014' =>
        test_zci("There are 2 weekdays between 03 Jan 2014 and 06 Jan 2014.", html => qr/.*/),

    # Same day
    'weekdays between jan 3, 2014 jan 3, 2014' =>
        test_zci("There is 1 weekday between 03 Jan 2014 and 03 Jan 2014.", html => qr/.*/),
    
    # Same day on a weekend
    'weekdays between jan 4, 2014 jan 4, 2014' =>
        test_zci("There are 0 weekdays between 04 Jan 2014 and 04 Jan 2014.", html => qr/.*/),
    
    # Starting on a Saturday
    'weekdays between 01/11/2014 01/14/2014' =>
        test_zci("There are 2 weekdays between 11 Jan 2014 and 14 Jan 2014.", html => qr/.*/),

    # Starting on a Sunday
    'weekdays between 01/12/2014 01/17/2014' =>
        test_zci("There are 5 weekdays between 12 Jan 2014 and 17 Jan 2014.", html => qr/.*/),

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
