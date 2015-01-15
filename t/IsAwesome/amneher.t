#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_amneher";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::amneher )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'duckduckhack amneher' => test_zci('amneher is awesome and has just completed the duckduckhack goodie tutorial!'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'duckduckhack amneher is awesome' => undef,
);

done_testing;
