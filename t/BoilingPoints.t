#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "boiling_points";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::BoilingPoints )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'boiling point of nitrogen' => test_zci('-195.79 degrees Celcius'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'boiling point of duckduckgo' => undef,
);

done_testing;
