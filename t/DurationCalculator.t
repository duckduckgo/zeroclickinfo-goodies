#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use Test::MockTime;
use DDG::Test::Goodie;

zci answer_type => "duration_calculator";
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my @test_params = @_;

    return $test_params[0],
        structured_answer => {

            data => {
                title    => $test_params[0],
                subtitle => $test_params[1],
            },

            templates => {
                group => "text",
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

my $add_query = "2 days 7 minutes 39 seconds + 1 day 9 hours 58 minutes 25 seconds";
my $sub_query = "1 day 9 hours 59 minutes 14 seconds - 1 day 9 hours 58 minutes 25 seconds";
my $add_query_plus = "1 day plus 48 hours";
my $sub_query_minus = "2 days minus 43 hours";
my $value_test = "1 second - 1000000000 nanoseconds";
my $month_test = "4 weeks + 2 days";
my $year_test = "23 months + 30 days";
my $neg_query1 = "1 year - 400 days";
my $neg_query2 = "1 day + -24 hours";
my $neg_query3 = "-1 week - 3 days";
my $neg_query4 = "-1 week + 7 days";
my $invalid_query1 = "2 day 2 day + 4 day";
my $invalid_query2 = "1 day + 1 hay";
my $invalid_query3 = "-54minutes - 39";
my $invalid_query4 = "4 hours";
Test::MockTime::set_absolute_time("2016-06-01T01:00:00Z");

ddg_goodie_test(
    [qw( DDG::Goodie::DurationCalculator )],
   
    $add_query => build_test("3 days, 10 hours, 6 minutes, and 4 seconds", $add_query),
    $sub_query => build_test("49 seconds", $sub_query),
    $add_query_plus => build_test("3 days", "1 day + 48 hours"),
    $sub_query_minus => build_test("5 hours", "2 days - 43 hours"),
    $value_test => build_test("no time", $value_test),
    $month_test => build_test("1 month", $month_test),
    $year_test => build_test("2 years", $year_test),
    $neg_query1 => build_test("-(1 month and 3 days)", $neg_query1),
    $neg_query2 => build_test("no time", $neg_query2),
    $neg_query3 => build_test("-(1 week and 3 days)", $neg_query3),
    $neg_query4 => build_test("no time", $neg_query4),
    $invalid_query1 => undef,
    $invalid_query3 =>undef,
    $invalid_query2 =>undef,
    $invalid_query4 =>undef,
);
Test::MockTime::restore();
done_testing;
