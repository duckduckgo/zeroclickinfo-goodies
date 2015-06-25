#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_valnermedeiros";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::valnermedeiros )],
    'duckduckhack valnermedeiros' => test_zci('ValnerMedeiros is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack valnermedeiros is awesome' => undef,
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    #'example query' => test_zci('query'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    #'bad example query' => undef,
);

done_testing;
