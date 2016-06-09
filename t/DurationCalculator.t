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
                # subtitle => "My Subtitle",
                # image => "http://website.com/image.png",
            },

            templates => {
                group => "text",
                # options => {
                #
                # }
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

my $add_query = "2 day 7 minutes 39 seconds + 1 day 9 hours 58 minutes 25 seconds";
my $sub_query = "1 day 9 hours 59 minutes 14 seconds - 1 day 9 hours 58 minutes 25 seconds";
    
ddg_goodie_test(
    [qw( DDG::Goodie::DurationCalculator )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    
    $add_query => build_test("3 days, 10 hours, 5 minutes, and 64 seconds"),
    $sub_query => build_test("49 seconds"),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    '2 hours 4 seconds 3 minutes + 2 hours 11 minutes 1 second' => undef,
);

done_testing;
