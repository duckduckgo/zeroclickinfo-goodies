#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_ymzong";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::ymzong )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'duckduckhack ymzong' => test_zci('ymzong is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'duckduckhack ymzong is awesome' => undef,
    'bad example query' => undef,
    'duckduckgo' => undef
);

done_testing;
