#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'number_sequences';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my ($raw_number, $type, $number, $result) = @_;

    return "$raw_number $type is:",
        structured_answer => {

            data => {
                title    => "$result",
                subtitle => "$raw_number $type number"
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
    [qw( DDG::Goodie::NumberSequences )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    '5th prime number' => build_test('5th', 'Prime', '5', '11'),
    '1st prime number' => build_test('1st', 'Prime', '1', '2'),
    '5th catalan number' => build_test('5th', 'Catalan', '5', '42'),
    '5st catalan number' => build_test('5th', 'Catalan', '5', '42'),
    '5th Tetrahedral number' => build_test('5th', 'Tetrahedral', '5', '35'),
    '5st Tetrahedral number' => build_test('5th', 'Tetrahedral', '5', '35'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    '5th duck number' => undef,
);

done_testing;
