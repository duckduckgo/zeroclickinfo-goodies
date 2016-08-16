#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'weekdays_between';
zci is_cached   => 0;

my @plural = qw(are Weekdays);
my @jan_6_to_10 = ('06 Jan 2014', '10 Jan 2014', 5, @plural);

sub build_structured_answer {
    my( $start_str, $end_str, $weekday_count, $verb, $weekday_plurality) = @_;

    my $response = "There $verb $weekday_count $weekday_plurality between $start_str and $end_str.";
    return $response,
        structured_answer => {
            data => {
                title    => $weekday_count,
                subtitle => "$weekday_plurality between $start_str - $end_str",
            },
            templates => {
                group => "text"
            }
        };
}

sub build_test{ test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw(DDG::Goodie::WeekdaysBetween)],

    # Primary query example
    'Weekdays between 2000-01-31 2001-01-31' => build_test('31 Jan 2000', '31 Jan 2001', 263, @plural),

    # Test different trigger words
    'week days between 2014-01-06 2014-01-10' => build_test(@jan_6_to_10),
    'week days from 2014-01-06 2014-01-10'    => build_test(@jan_6_to_10),
    'Weekdays from 2014-01-06 2014-01-10'     => build_test(@jan_6_to_10),

    # Standard work week
    'Weekdays between 2014-01-06 2014-01-10' => build_test(@jan_6_to_10),

    # Ending date first
    'Weekdays between 2014-01-06 2014-01-10' => build_test(@jan_6_to_10),

    # Including the weekend -- Backwards
    'Weekdays between 2014-01-13 2014-01-06' => build_test('06 Jan 2014', '13 Jan 2014', 6, @plural),

    # Weekdays in a year
    'Weekdays between 2014-01-01 2015-01-01' => build_test('01 Jan 2014', '01 Jan 2015', 262, @plural),

    # Weekend in the middle
    'Weekdays between jan 3, 2014 jan 6, 2014' => build_test('03 Jan 2014', '06 Jan 2014', 2, @plural),

    # Same day
    'Weekdays between jan 3, 2014 jan 3, 2014' => build_test('03 Jan 2014', '03 Jan 2014', 1, 'is', 'Weekday'),

    # Same day on a weekend
    'Weekdays between jan 4, 2014 jan 4, 2014' => build_test('04 Jan 2014', '04 Jan 2014', 0, @plural),

    # Starting on a Saturday
    'Weekdays between 2014-01-11 2014-01-14' => build_test('11 Jan 2014', '14 Jan 2014', 2, @plural),

    # Starting on a Sunday
    'Weekdays between 2014-01-12 2014-01-17' => build_test('12 Jan 2014', '17 Jan 2014', 5, @plural),

    # Invalid input
    'Weekdays between 01/2013 and 01/2014'                 => undef,
    'Weekdays between feb 30, 2014 to mar 3, 2014'         => undef,
    'Weekdays between 01/01/2012'                          => undef,
    'Weekdays between 18/17/2013 21/23/2015'               => undef,
    'Weekdays between 01/2013 and 01/2014 inclusive'       => undef,
    'Weekdays between feb 30, 2014 mar 3, 2014 inclusive'  => undef,
    'Weekdays between 01/01/2012 to'                       => undef,
    'Weekdays between 18/17/2013 and 21/23/2015 inclusive' => undef,
);

done_testing;
