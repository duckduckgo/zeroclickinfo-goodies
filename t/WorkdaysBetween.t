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
        test_zci('There are 4 workdays between 01/06/2014 and 01/10/2014.'),
    'workdays between 01/06/2014 01/10/2014 inclusive' =>
        test_zci('There are 5 workdays between 01/06/2014 and 01/10/2014, inclusive.'),

    # Ending date first
    'workdays between 01/10/2014 01/06/2014'  =>
        test_zci('There are 4 workdays between 01/06/2014 and 01/10/2014.'),
    'workdays between 01/10/2014 01/06/2014 inclusive' =>
        test_zci('There are 5 workdays between 01/06/2014 and 01/10/2014, inclusive.'),

    # Ending date on a weekend
    'workdays between 01/06/2014 01/12/2014' =>
        test_zci('There are 4 workdays between 01/06/2014 and 01/12/2014.'),
    'workdays between 01/06/2014 01/12/2014 inclusive' =>
        test_zci('There are 5 workdays between 01/06/2014 and 01/12/2014, inclusive.'),

    # Including the weekend
    'workdays between 01/06/2014 01/13/2014' =>
        test_zci('There are 5 workdays between 01/06/2014 and 01/13/2014.'),
    'workdays between 01/06/2014 01/13/2014 inclusive' =>
        test_zci('There are 6 workdays between 01/06/2014 and 01/13/2014, inclusive.'),

    # Including the weekend -- Backwards
    'workdays between 01/13/2014 01/06/2014' =>
        test_zci('There are 5 workdays between 01/06/2014 and 01/13/2014.'),
    'workdays between 01/13/2014 01/06/2014 inclusive' =>
        test_zci('There are 6 workdays between 01/06/2014 and 01/13/2014, inclusive.'),

    # Starting on a Saturday
    'workdays between 01/11/2014 01/14/2014' =>
        test_zci('There are 2 workdays between 01/11/2014 and 01/14/2014.'),
    'workdays between 01/11/2014 01/14/2014 inclusive' =>
        test_zci('There are 2 workdays between 01/11/2014 and 01/14/2014.'),

    # Starting on a Sunday
    'workdays between 01/12/2014 01/14/2014' =>
        test_zci('There are 2 workdays between 01/12/2014 and 01/14/2014.'),
    'workdays between 01/12/2014 01/14/2014 inclusive' =>
        test_zci('There are 2 workdays between 01/12/2014 and 01/14/2014.'),

    # Workdays in a year
    'workdays between 01/01/2014 01/01/2015' =>
        test_zci('There are 261 workdays between 01/01/2014 and 01/01/2015.'),
    'workdays between 01/01/2014 01/01/2015 inclusive' =>
        test_zci('There are 262 workdays between 01/01/2014 and 01/01/2015, inclusive.'),

    # Invalid input
    'workdays between 01/2014 01/2015' => undef,
    'workdays between 01/2014/01' => undef,
    'workdays between 01/01/2014 inclusive' => undef,
);

done_testing;
