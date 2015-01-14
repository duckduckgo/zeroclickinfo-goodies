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
            operation => "Calculate",
            result => 6
        }),
    '456+120%' => test_zci('Result: 1003.2',
        structured_answer => {
            input => ["456+120%"],
            operation => "Calculate",
            result => 1003.2
        }),
    '3.4+6%' => test_zci('Result: 3.604',
        structured_answer => {
            input => ["3.4+6%"],
            operation => "Calculate",
            result => 3.604
        }),
    '323.7+55.3%' => test_zci('Result: 502.7061',
        structured_answer => {
            input => ["323.7+55.3%"],
            operation => "Calculate",
            result => 502.7061
        }),

    'urldecode hello%20there' => undef,
    '34$+16' => undef,
    '12+5t%' => undef
);

done_testing;
