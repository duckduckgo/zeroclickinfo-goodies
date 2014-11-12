#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "percent_of";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::PercentOf )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    '4+50%' => test_zci('Result: 6'),
    '456+120%' => test_zci('Result: 1003.2'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'bad example query' => undef,
);

done_testing;
