#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "descent_planner";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::DescentPlanner )],
    # Good queries
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'descend from 350 to 30' => test_zci('To descend from 350 to 30, begin about 107 nautical miles from your target'),
    'descend from FL350 to 30' => test_zci('To descend from FL350 to 30, begin about 107 nautical miles from your target'),
    'descend from fL350 to Fl30' => test_zci('To descend from fL350 to Fl30, begin about 107 nautical miles from your target'),
    'descend from 230 to 30' => test_zci('To descend from 230 to 30, begin about 67 nautical miles from your target'),
    'descend from 230 to FL30' => test_zci('To descend from 230 to FL30, begin about 67 nautical miles from your target'),
    'descend from 230toFL30' => test_zci('To descend from 230toFL30, begin about 67 nautical miles from your target'),
    
    # Bad queries
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'descend from here to there' => undef,
    'descend from 350 to a9' => undef,
    'descend from 35 to 29' => undef,
);

done_testing;
