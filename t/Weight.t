#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "weight";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Weight )],
    # - primary_example_queries
    'What is the weight of a 5kg mass on Earth?' => test_zci("Weight of a 5kg mass on Earth is 49.03325N.", structured_answer => { input =>[], operation => "Taking value of acceleration due to gravity on Earth as 9.80665m/s^2.", result =>"Weight of a 5kg mass on Earth is 49.03325N."}),
    'weight 5.12g' => test_zci("Weight of a 5.12g mass on Earth is 0.050210048N.", structured_answer => { input =>[], operation => "Taking value of acceleration due to gravity on Earth as 9.80665m/s^2.", result =>"Weight of a 5.12g (0.00512 kg) mass on Earth is 0.050210048N."}),
    'weight 5.12oz' => test_zci("Weight of a 5.12oz mass on Earth is 1.4209443584N.", structured_answer => { input =>[], operation => "Taking value of acceleration due to gravity on Earth as 9.80665m/s^2.", result =>"Weight of a 5.12oz (0.144896 kg) mass on Earth is 1.4209443584N."}),
    'Weight of 5.1 kg on earth' => test_zci("Weight of a 5.1kg mass on Earth is 50.013915N.", structured_answer => { input =>[], operation => "Taking value of acceleration due to gravity on Earth as 9.80665m/s^2.", result =>"Weight of a 5.1kg mass on Earth is 50.013915N."}),
    # Bad example queries
    'weight' => undef,
    'weight abc' => undef,
    'weight 5' => undef,
);

done_testing;
