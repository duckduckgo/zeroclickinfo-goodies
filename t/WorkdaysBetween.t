#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'workdays_between';
zci is_cached   => 0;

my @six_to_ten = (
    'There are 5 workdays between 06 Jan 2014 and 10 Jan 2014.',
    structured_answer => {
        input     => ['06 Jan 2014', '10 Jan 2014'],
        operation => 'workdays between',
        result    => 5,
    });
my @twentyfourteen = (
    'There are 251 workdays between 01 Jan 2014 and 01 Jan 2015.',
    structured_answer => {
        input     => ['01 Jan 2014', '01 Jan 2015'],
        operation => 'workdays between',
        result    => 251,
    });
my @twoohoh = (
    'There are 253 workdays between 31 Jan 2000 and 31 Jan 2001.',
    structured_answer => {
        input     => ['31 Jan 2000', '31 Jan 2001'],
        operation => 'workdays between',
        result    => 253,
    });
my @midjune = (
    'There are 12 workdays between 05 Jun 2014 and 20 Jun 2014.',
    structured_answer => {
        input     => ['05 Jun 2014', '20 Jun 2014'],
        operation => 'workdays between',
        result    => 12,
    });
my @midjan = (
    'There are 6 workdays between 06 Jan 2014 and 13 Jan 2014.',
    structured_answer => {
        input     => ['06 Jan 2014', '13 Jan 2014'],
        operation => 'workdays between',
        result    => 6,
    });
my @somejan = (
    'There are 5 workdays between 06 Jan 2014 and 12 Jan 2014.',
    structured_answer => {
        input     => ['06 Jan 2014', '12 Jan 2014'],
        operation => 'workdays between',
        result    => 5,
    });
my @somesat = (
    'There are 2 workdays between 11 Jan 2014 and 14 Jan 2014.',
    structured_answer => {
        input     => ['11 Jan 2014', '14 Jan 2014'],
        operation => 'workdays between',
        result    => 2,
    });
my @somesun = (
    'There are 2 workdays between 12 Jan 2014 and 14 Jan 2014.',
    structured_answer => {
        input     => ['12 Jan 2014', '14 Jan 2014'],
        operation => 'workdays between',
        result    => 2,
    });
my @latejun = (
    'There are 5 workdays between 16 Jun 2014 and 20 Jun 2014.',
    structured_answer => {
        input     => ['16 Jun 2014', '20 Jun 2014'],
        operation => 'workdays between',
        result    => 5,
    });
my @sameday = (
    'There is 1 workday between 03 Jan 2014 and 03 Jan 2014.',
    structured_answer => {
        input     => ['03 Jan 2014', '03 Jan 2014'],
        operation => 'workday between',
        result    => 1,
    });
my @samedaywknd = (
    'There are 0 workdays between 04 Jan 2014 and 04 Jan 2014.',
    structured_answer => {
        input     => ['04 Jan 2014', '04 Jan 2014'],
        operation => 'workdays between',
        result    => 0,
    });
my @weekend_middle = (
    'There are 2 workdays between 03 Jan 2014 and 06 Jan 2014.',
    structured_answer => {
        input     => ['03 Jan 2014', '06 Jan 2014'],
        operation => 'workdays between',
        result    => 2,
    });

ddg_goodie_test(
    ['DDG::Goodie::WorkdaysBetween'],

    # Standard work week
    'workdays between 01/06/2014 01/10/2014'           => test_zci(@six_to_ten),
    'workdays between 01/06/2014 01/10/2014 inclusive' => test_zci(@six_to_ten),

    # Ending date first
    'workdays between 01/10/2014 01/06/2014'           => test_zci(@six_to_ten),
    'workdays between 01/10/2014 01/06/2014 inclusive' => test_zci(@six_to_ten),

    # Ending date on a weekend
    'workdays between 01/06/2014 01/12/2014'           => test_zci(@somejan),
    'workdays between 01/06/2014 01/12/2014 inclusive' => test_zci(@somejan),

    # Including the weekend
    'workdays between 01/06/2014 01/13/2014'           => test_zci(@midjan),
    'workdays between 01/06/2014 01/13/2014 inclusive' => test_zci(@midjan),

    # Including the weekend -- Backwards
    'workdays between 01/13/2014 01/06/2014'           => test_zci(@midjan),
    'workdays between 01/13/2014 01/06/2014 inclusive' => test_zci(@midjan),

    # Starting on a Saturday
    'workdays between 01/11/2014 01/14/2014'           => test_zci(@somesat),
    'workdays between 01/11/2014 01/14/2014 inclusive' => test_zci(@somesat),

    # Starting on a Sunday
    'workdays between 01/12/2014 01/14/2014'           => test_zci(@somesun),
    'workdays between 01/12/2014 01/14/2014 inclusive' => test_zci(@somesun),

    # Workdays in a year
    'workdays between 01/01/2014 01/01/2015'           => test_zci(@twentyfourteen),
    'workdays between 01/01/2014 01/01/2015 inclusive' => test_zci(@twentyfourteen),

    # Business Days
    'business days between 01/06/2014 01/10/2014'           => test_zci(@six_to_ten),
    'business days between 01/06/2014 01/10/2014 inclusive' => test_zci(@six_to_ten),

    # Month and Date are backwards
    'workdays between 16/06/2014 20/06/2014' => test_zci(@latejun),
    'workdays between 5/06/2014 20/06/2014'  => test_zci(@midjune),
    'workdays between 20/06/2014 5/06/2014'  => test_zci(@midjune),

    # Single digit days and months
    'workdays between 1/6/2014 1/10/2014'           => test_zci(@six_to_ten),
    'workdays between 1/6/2014 1/10/2014 inclusive' => test_zci(@six_to_ten),

    # Workdays in a year - Dash format
    'workdays between 01-01-2014 01-01-2015'           => test_zci(@twentyfourteen),
    'workdays between 01-01-2014 01-01-2015 inclusive' => test_zci(@twentyfourteen),

    # Business Days - Dash format
    'business days between 01-06-2014 01-10-2014'           => test_zci(@six_to_ten),
    'business days between 01-06-2014 01-10-2014 inclusive' => test_zci(@six_to_ten),

    # Month and Date are backwards - Dash format
    'workdays between 16-06-2014 20-06-2014' => test_zci(@latejun),
    'workdays between 5-06-2014 20-06-2014'  => test_zci(@midjune),
    'workdays between 20-06-2014 5-06-2014'  => test_zci(@midjune),

    # Single digit days and months - Dash format
    'workdays between 1-6-2014 1-10-2014'           => test_zci(@six_to_ten),
    'workdays between 1-6-2014 1-10-2014 inclusive' => test_zci(@six_to_ten),

    # Unambiguous date format
    'workdays between jan 6 2014 jan 10 2014'           => test_zci(@six_to_ten),
    'workdays between jan 6 2014 jan 10 2014 inclusive' => test_zci(@six_to_ten),

    # Unambiguous date format with comma separator
    'workdays between jan 6, 2014 jan 10, 2014'           => test_zci(@six_to_ten),
    'workdays between jan 6, 2014 jan 10, 2014 inclusive' => test_zci(@six_to_ten),

    # Same day
    'workdays between jan 3, 2014 jan 3, 2014'           => test_zci(@sameday),
    'workdays between jan 3, 2014 jan 3, 2014 inclusive' => test_zci(@sameday),

    # Same day on a weekend
    'workdays between jan 4, 2014 jan 4, 2014'           => test_zci(@samedaywknd),
    'workdays between jan 4, 2014 jan 4, 2014 inclusive' => test_zci(@samedaywknd),

    # Weekend in the middle
    'workdays between jan 3, 2014 jan 6, 2014'           => test_zci(@weekend_middle),
    'workdays between jan 3, 2014 jan 6, 2014 inclusive' => test_zci(@weekend_middle),

    # "to"
    'workdays between jan 3, 2014 to jan 6, 2014'           => test_zci(@weekend_middle),
    'workdays between jan 3, 2014 to jan 6, 2014 inclusive' => test_zci(@weekend_middle),

    'business days between jan 10 and jan 20' => test_zci(
        qr"There are [1-9] workdays between 10 Jan [0-9]{4} and 20 Jan [0-9]{4}\.",
        structured_answer => {
            input     => '-ANY-',
            operation => 'workdays between',
            result    => qr/[1-9]/,
        }
    ),

    'business days between january and february' => test_zci(
        qr"There are [1-9][0-9] workdays between 01 Jan [0-9]{4} and 01 Feb [0-9]{4}\.",
        structured_answer => {
            input     => '-ANY-',
            operation => 'workdays between',
            result    => qr/[1-9][0-9]/,
        }
    ),

    'workdays between 01/31/2000 01/31/2001'               => test_zci(@twoohoh),
    'workdays between 01/31/2000 01/31/2001 inclusive'     => test_zci(@twoohoh),
    'workdays between 01/31/2000 and 01/31/2001 inclusive' => test_zci(@twoohoh),
    'workdays between jan 3 2013 and jan 4 2013'           => test_zci(
        "There are 2 workdays between 03 Jan 2013 and 04 Jan 2013.",
        structured_answer => {
            input     => ['03 Jan 2013', '04 Jan 2013'],
            operation => 'workdays between',
            result    => 2,
        }
    ),

    # Invalid input
    'workdays between 01/2014 01/2015'                 => undef,
    'workdays between 01/2014/01'                      => undef,
    'workdays between 01/01/2014 inclusive'            => undef,
    'workdays between 01/01/2014'                      => undef,
    'workdays between 20/01/2014 inclusive'            => undef,
    'workdays between 19/19/2014 20/24/2015'           => undef,
    'workdays between 19/19/2014 20/24/2015 inclusive' => undef,
    'workdays from FEB 30 2014 to March 24 2014'       => undef,
);

done_testing;
