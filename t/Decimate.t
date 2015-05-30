#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "decimate";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Decimate )],
    # Good queries:
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    # "decimate", "divide", "longdiv", "long div", "long divide", "long division";
    'decimate 22 by 7' => test_zci('22 / 7 = 3.142857 (last 6 digits repeat)'),
    'decimate 22 / 7' => test_zci('22 / 7 = 3.142857 (last 6 digits repeat)'),
    'decimate 22/7' => test_zci('22 / 7 = 3.142857 (last 6 digits repeat)'),
    'divide 22 by 7' => test_zci('22 / 7 = 3.142857 (last 6 digits repeat)'),
    'divide 22 / 7' => test_zci('22 / 7 = 3.142857 (last 6 digits repeat)'),
    'divide 22/7' => test_zci('22 / 7 = 3.142857 (last 6 digits repeat)'),
    'longdiv 22 / 7' => test_zci('22 / 7 = 3.142857 (last 6 digits repeat)'),
    'long div 22 / 7' => test_zci('22 / 7 = 3.142857 (last 6 digits repeat)'),
    'long divide 22 / 7' => test_zci('22 / 7 = 3.142857 (last 6 digits repeat)'),
    'long division 22 / 7' => test_zci('22 / 7 = 3.142857 (last 6 digits repeat)'),

    # Bad queries:
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    '22 / 7' => undef,
    'divide 22 into 7' => undef,
);

done_testing;
