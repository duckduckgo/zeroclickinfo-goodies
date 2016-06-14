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
my $invalid_query = "2 day 2 day + 4 day";
ddg_goodie_test(
    [qw( DDG::Goodie::DurationCalculator )],
    
    
    $add_query => build_test("3 days, 10 hours, 6 minutes, and 4 seconds"),
    $sub_query => build_test("49 seconds"),
    $invalid_query => undef,
);

done_testing;
