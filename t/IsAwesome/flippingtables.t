#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "days_in_month";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::flippingtables )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'how many days are in january'  => test_zci('31'),
    'days in february'              => test_zci('28'),
    'number of days in march'       => test_zci('31'),
    'how many days are in february' => test_zci('28'),
    'how many days are in spiderman' => undef,
    'how many bananas are you' => undef,
);

done_testing;
