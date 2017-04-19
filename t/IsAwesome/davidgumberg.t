#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_davidgumberg";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::davidgumberg )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'duckduckhack davidgumberg' => test_zci('davidgumberg is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'duckduckhack davidgumberg is awesome' => undef,
);

done_testing;
