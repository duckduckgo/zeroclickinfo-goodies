#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "git";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Git )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    #'git something' => test_zci('result'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'agitate' => undef,
);

done_testing;
