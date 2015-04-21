#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "weight";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Weight )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'weight 5' => test_zci('Weight of a 5kg mass on Earth is 49.03325N. Note: Taking value of acceleration due to gravity on Earth as 9.80665m/s^2.'),
    'weight 5.12' => test_zci('Weight of a 5.12kg mass on Earth is 50.210048N. Note: Taking value of acceleration due to gravity on Earth as 9.80665m/s^2.'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'weight' => undef,
    'weight abc' => undef,
);

done_testing;
