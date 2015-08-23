#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_alexander95015";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::alexander95015 )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'duckduckhack alexander95015' => test_zci('alexander95015 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack alexander95015 is awesome' => undef,
);

done_testing;
