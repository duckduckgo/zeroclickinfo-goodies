#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_blainester";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::blainester )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'duckduckhack blainester' => test_zci('blainester is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'duckduckhack blainester is awesome' => undef,
);

done_testing;
