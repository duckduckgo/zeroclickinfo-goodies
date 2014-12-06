#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "Number of days in a month";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::flippingtables )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    #'example query' => test_zci('query'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
   'how many days are in january' => test_zci('31'),
   'how many days are in february' => test_zci('28'),
   'how many days are in spiderman' => undef,
   'how many bananas are you' => undef,
);

done_testing;
