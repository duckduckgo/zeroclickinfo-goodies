#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "percent_of";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::PercentOf )],

    '4+50%' => test_zci('Result: 6',
        structured_answer => {
            input => ["4+50%"],
            operation => "calculate",
            result => 6
        }),

    '456+120%' => test_zci('Result: 1003.2',
        structured_answer => {
            input => ["456+120%"],
            operation => "calculate",
            result => 1003.2
        }),

    'bad example query' => undef,
);

done_testing;
