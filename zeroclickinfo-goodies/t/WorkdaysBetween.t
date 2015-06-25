#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

use Test::MockTime qw( :all );

zci answer_type => 'workdays_between';
zci is_cached   => 0;

my @six_to_ten = (
    'There are 5 Workdays between 06 Jan 2014 and 10 Jan 2014.',
    structured_answer => {
        input     => ['06 Jan 2014', '10 Jan 2014'],
        operation => 'Workdays between',
        result    => 5,
    });
my @twentyfourteen = (
    'There are 251 Workdays between 01 Jan 2014 and 01 Jan 2015.',
    structured_answer => {
        input     => ['01 Jan 2014', '01 Jan 2015'],
        operation => 'Workdays between',
        result    => 251,
    });
my @twoohoh = (
    'There are 253 Workdays between 31 Jan 2000 and 31 Jan 2001.',
    structured_answer => {
        input     => ['31 Jan 2000', '31 Jan 2001'],
        operation => 'Workdays between',
        result    => 253,
    });
my @midjune = (
    'There are 12 Workdays between 05 Jun 2014 and 20 Jun 2014.',
    structured_answer => {
        input     => ['05 Jun 2014', '20 Jun 2014'],
        operation => 'Workdays between',
        result    => 12,
    });
my @midjan = (
    'There are 6 Workdays between 06 Jan 2014 and 13 Jan 2014.',
    structured_answer => {
        input     => ['06 Jan 2014', '13 Jan 2014'],
        operation => 'Workdays between',
        result    => 6,
    });
my @somejan = (
    'There are 5 Workdays between 06 Jan 2014 and 12 Jan 2014.',
    structured_answer => {
        input     => ['06 Jan 2014', '12 Jan 2014'],
        operation => 'Workdays between',
        result    => 5,
    });
my @somesat = (
    'There are 2 Workdays between 11 Jan 2014 and 14 Jan 2014.',
    structured_answer => {
        input     => ['11 Jan 2014', '14 Jan 2014'],
        operation => 'Workdays between',
        result    => 2,
    });
my @somesun = (
    'There are 2 Workdays between 12 Jan 2014 and 14 Jan 2014.',
    structured_answer => {
        input     => ['12 Jan 2014', '14 Jan 2014'],
        operation => 'Workdays between',
        result    => 2,
    });
my @latejun = (
    'There are 5 Workdays between 16 Jun 2014 and 20 Jun 2014.',
    structured_answer => {
        input     => ['16 Jun 2014', '20 Jun 2014'],
        operation => 'Workdays between',
        result    => 5,
    });
my @sameday = (
    'There is 1 Workday between 03 Jan 2014 and 03 Jan 2014.',
    structured_answer => {
        input     => ['03 Jan 2014', '03 Jan 2014'],
        operation => 'Workday between',
        result    => 1,
    });
my @samedaywknd = (
    'There are 0 Workdays between 04 Jan 2014 and 04 Jan 2014.',
    structured_answer => {
        input     => ['04 Jan 2014', '04 Jan 2014'],
        operation => 'Workdays between',
        result    => 0,
    });
my @weekend_middle = (
    'There are 2 Workdays between 03 Jan 2014 and 06 Jan 2014.',
    structured_answer => {
        input     => ['03 Jan 2014', '06 Jan 2014'],
        operation => 'Workdays between',
        result    => 2,
    });

ddg_goodie_test(
    ['DDG::Goodie::WorkdaysBetween'],

    # Standard work week
    'Workdays between 01/06/2014 01/10/2014'           => test_zci(@six_to_ten),
    'Workdays between 01/06/2014 01/10/2014 inclusive' => test_zci(@six_to_ten),

    # Ending date first
    'Workdays between 01/10/2014 01/06/2014'           => test_zci(@six_to_ten),
    'Workdays between 01/10/2014 01/06/2014 inclusive' => test_zci(@six_to_ten),

    # Ending date on a weekend
    'Workdays between 01/06/2014 01/12/2014'           => test_zci(@somejan),
    'Workdays between 01/06/2014 01/12/2014 inclusive' => test_zci(@somejan),

    # Including the weekend
    'Workdays between 01/06/2014 01/13/2014'           => test_zci(@midjan),
    'Workdays between 01/06/2014 01/13/2014 inclusive' => test_zci(@midjan),

    # Including the weekend -- Backwards
    'Workdays between 01/13/2014 01/06/2014'           => test_zci(@midjan),
    'Workdays between 01/13/2014 01/06/2014 inclusive' => test_zci(@midjan),

    # Starting on a Saturday
    'Workdays between 01/11/2014 01/14/2014'           => test_zci(@somesat),
    'Workdays between 01/11/2014 01/14/2014 inclusive' => test_zci(@somesat),

    # Starting on a Sunday
    'Workdays between 01/12/2014 01/14/2014'           => test_zci(@somesun),
    'Workdays between 01/12/2014 01/14/2014 inclusive' => test_zci(@somesun),

    # Workdays in a year
    'Workdays between 01/01/2014 01/01/2015'           => test_zci(@twentyfourteen),
    'Workdays between 01/01/2014 01/01/2015 inclusive' => test_zci(@twentyfourteen),

    # Business Days
    'business days between 01/06/2014 01/10/2014'           => test_zci(@six_to_ten),
    'business days between 01/06/2014 01/10/2014 inclusive' => test_zci(@six_to_ten),

    # Month and Date are backwards
    'Workdays between 16/06/2014 20/06/2014' => test_zci(@latejun),
    'Workdays between 5/06/2014 20/06/2014'  => test_zci(@midjune),
    'Workdays between 20/06/2014 5/06/2014'  => test_zci(@midjune),

    # Single digit days and months
    'Workdays between 1/6/2014 1/10/2014'           => test_zci(@six_to_ten),
    'Workdays between 1/6/2014 1/10/2014 inclusive' => test_zci(@six_to_ten),

    # Workdays in a year - Dash format
    'Workdays between 01-01-2014 01-01-2015'           => test_zci(@twentyfourteen),
    'Workdays between 01-01-2014 01-01-2015 inclusive' => test_zci(@twentyfourteen),

    # Business Days - Dash format
    'business days between 01-06-2014 01-10-2014'           => test_zci(@six_to_ten),
    'business days between 01-06-2014 01-10-2014 inclusive' => test_zci(@six_to_ten),

    # Month and Date are backwards - Dash format
    'Workdays between 16-06-2014 20-06-2014' => test_zci(@latejun),
    'Workdays between 5-06-2014 20-06-2014'  => test_zci(@midjune),
    'Workdays between 20-06-2014 5-06-2014'  => test_zci(@midjune),

    # Single digit days and months - Dash format
    'Workdays between 1-6-2014 1-10-2014'           => test_zci(@six_to_ten),
    'Workdays between 1-6-2014 1-10-2014 inclusive' => test_zci(@six_to_ten),

    # Unambiguous date format
    'Workdays between jan 6 2014 jan 10 2014'           => test_zci(@six_to_ten),
    'Workdays between jan 6 2014 jan 10 2014 inclusive' => test_zci(@six_to_ten),

    # Unambiguous date format with comma separator
    'Workdays between jan 6, 2014 jan 10, 2014'           => test_zci(@six_to_ten),
    'Workdays between jan 6, 2014 jan 10, 2014 inclusive' => test_zci(@six_to_ten),

    # Same day
    'Workdays between jan 3, 2014 jan 3, 2014'           => test_zci(@sameday),
    'Workdays between jan 3, 2014 jan 3, 2014 inclusive' => test_zci(@sameday),

    # Same day on a weekend
    'Workdays between jan 4, 2014 jan 4, 2014'           => test_zci(@samedaywknd),
    'Workdays between jan 4, 2014 jan 4, 2014 inclusive' => test_zci(@samedaywknd),

    # Weekend in the middle
    'Workdays between jan 3, 2014 jan 6, 2014'           => test_zci(@weekend_middle),
    'Workdays between jan 3, 2014 jan 6, 2014 inclusive' => test_zci(@weekend_middle),

    # "to"
    'Workdays between jan 3, 2014 to jan 6, 2014'           => test_zci(@weekend_middle),
    'Workdays between jan 3, 2014 to jan 6, 2014 inclusive' => test_zci(@weekend_middle),

    'Workdays between 01/31/2000 01/31/2001'               => test_zci(@twoohoh),
    'Workdays between 01/31/2000 01/31/2001 inclusive'     => test_zci(@twoohoh),
    'Workdays between 01/31/2000 and 01/31/2001 inclusive' => test_zci(@twoohoh),
    'Workdays between jan 3 2013 and jan 4 2013'           => test_zci(
        "There are 2 Workdays between 03 Jan 2013 and 04 Jan 2013.",
        structured_answer => {
            input     => ['03 Jan 2013', '04 Jan 2013'],
            operation => 'Workdays between',
            result    => 2,
        }
    ),

    # Invalid input
    'Workdays between 01/2014 01/2015'                 => undef,
    'Workdays between 01/2014/01'                      => undef,
    'Workdays between 01/01/2014 inclusive'            => undef,
    'Workdays between 01/01/2014'                      => undef,
    'Workdays between 20/01/2014 inclusive'            => undef,
    'Workdays between 19/19/2014 20/24/2015'           => undef,
    'Workdays between 19/19/2014 20/24/2015 inclusive' => undef,
    'Workdays from FEB 30 2014 to March 24 2014'       => undef,
);

set_fixed_time("2015-01-11T09:45:56");
ddg_goodie_test(
    [qw(
        DDG::Goodie::WorkdaysBetween
    )],
    'business days between jan 10 and jan 20' => test_zci(
        qr"There are [1-9] Workdays between 10 Jan [0-9]{4} and 20 Jan [0-9]{4}\.",
        structured_answer => {
            input     => '-ANY-',
            operation => 'Workdays between',
            result    => qr/[1-9]/,
        }
    ),

    'business days between january and february' => test_zci(
        qr"There are [1-9][0-9] Workdays between 01 Jan [0-9]{4} and 01 Feb [0-9]{4}\.",
        structured_answer => {
            input     => '-ANY-',
            operation => 'Workdays between',
            result    => qr/[1-9][0-9]/,
        }
    ),
);

done_testing;
