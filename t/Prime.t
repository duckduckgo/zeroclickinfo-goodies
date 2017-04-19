#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'prime';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my @test_params = @_;

    return 'plain text response',
        structured_answer => {

            data => {
                title    => 'My Instant Answer Title',
                subtitle => 'My Subtitle',
                # image => 'http://website.com/image.png',
            },

            templates => {
                group => 'text',
                # options => {
                #
                # }
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Prime )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    
    'test 13 prime' => test_zci(
        "13 is a prime number",
        structured_answer => {
            data => {
                title => "Prime",
                subtitle => "13 is only divisible by itself and 1"
            },
            templates => {
                group => "text",
            }
        }
    )
);

done_testing;
