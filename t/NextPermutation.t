#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'next_permutation';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my ($sequence, $result) = @_;

    return "Next Permutation of the Sequence is $result",
        structured_answer => {

            data => {
                title    => $result,
                subtitle => 'Lexicographically Next Permutation of Sequence'
            },

            templates => {
                group => 'text'
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::NextPermutation )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'next permutation 12345' => build_test('12345','12354'),
    'next permutation abcd' => build_test('abcd','abdc'),
    'next permutation dhck' => build_test('dhck', 'dhkc'),
    'next permutation dkhc' => build_test('dkhc', 'hcdk'),
    'next permutation ab' => build_test('ab', 'ba'),
    'next permutation 218765' => build_test('218765', '251678'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'next permutation 54321' => undef, 
    'next permutation bb' => undef,
    'next permutation 4321' => undef, 
    #'next permutation 1 2 3 4' => undef,
);

done_testing;
