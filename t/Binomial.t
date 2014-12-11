#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "binomial";
zci is_cached   => 1;

my @table = (
    [1, 0, 0,  0,  0,  0,  0,  0, 0, 0,0],
    [1, 1, 0,  0,  0,  0,  0,  0, 0, 0,0],
    [1, 2, 1,  0,  0,  0,  0,  0, 0, 0,0],
    [1, 3, 3,  1,  0,  0,  0,  0, 0, 0,0],
    [1, 4, 6,  4,  1,  0,  0,  0, 0, 0,0],
    [1, 5,10, 10,  5,  1,  0,  0, 0, 0,0],
    [1, 6,15, 20, 15,  6,  1,  0, 0, 0,0],
    [1, 7,21, 35, 35, 21,  7,  1, 0, 0,0],
    [1, 8,28, 56, 70, 56, 28,  8, 1, 0,0],
    [1, 9,36, 84,126,126, 84, 36, 9, 1,0],
    [1,10,45,120,210,252,210,120,45,10,1],
);

sub test_queries {
    my @tests;
    for my $i (0..$#table) {
        for my $j (0..$#{$table[$i]}) {
            my $query = "binomial($i, $j)";
            my $expected_result = $table[$i]->[$j];
            my $expected_response = "binomial($i, $j) = $expected_result";

            push @tests, $query => test_zci($expected_response);
        }
    }
    return @tests;
}

ddg_goodie_test(
    [qw( DDG::Goodie::Binomial )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'binomial(7, 1)' => test_zci('binomial(7, 1) = 7'),
    'binomial(7,5)' => test_zci('binomial(7, 5) = 21'),
    '3 choose 2' => test_zci('binomial(3, 2) = 3'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'derp' => undef,
    'binomial(7, -1)' => undef,
    '7 choose -1' => undef,
    # A more complete test of the function
    test_queries(),
);

done_testing;
