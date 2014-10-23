#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "<: $lia_name :>";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::<: $ia_package_name :> )],

    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'example query' => test_zci(
        'expected output',
        structured_answer => {
            input     => ['expeced input'],
            operation => 'expected operation',
            result    => 'expected result'
        }
    ),

    # Try to include some examples queries which may
    # trigger you instant answer, but should not return
    # a result
    'bad example query' => undef,
);

done_testing;
