#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
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
my $invalid_query = "2 day 2 day + 4 day";
ddg_goodie_test(
    [qw( DDG::Goodie::DurationCalculator )],
        
    $add_query => build_test("3 days, 10 hours, 6 minutes, and 4 seconds", $add_query),
    $sub_query => build_test("49 seconds", $sub_query),
    $add_query_plus => build_test("3 days", "1 day + 48 hours"),
    $sub_query_minus => build_test("5 hours", "2 days - 43 hours"),
    $value_test => build_test("no time", $value_test),
    $month_test => build_test("1 month", $month_test),
    $year_test => build_test("2 years", $year_test),
    $invalid_query => undef,
);

done_testing;
