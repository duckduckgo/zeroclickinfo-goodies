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
    'weight 5' => test_zci("Weight of a 5kg mass on Earth is 49.03325N.", structured_answer => { input =>[], operation => "Taking value of acceleration due to gravity on Earth as 9.80665m/s^2.", result =>"Weight of a 5kg mass on Earth is 49.03325N."}),
    'weight 5.12' => test_zci("Weight of a 5.12kg mass on Earth is 50.210048N.", structured_answer => { input =>[], operation => "Taking value of acceleration due to gravity on Earth as 9.80665m/s^2.", result =>"Weight of a 5.12kg mass on Earth is 50.210048N."}),
    '5.1 weight' => test_zci("Weight of a 5.1kg mass on Earth is 50.013915N.", structured_answer => { input =>[], operation => "Taking value of acceleration due to gravity on Earth as 9.80665m/s^2.", result =>"Weight of a 5.1kg mass on Earth is 50.013915N."}),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'weight' => undef,
    'weight abc' => undef,
);

done_testing;
