#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'fibonacci';
zci is_cached   => 1;

ddg_goodie_test(
    [qw(DDG::Goodie::Fibonacci)],
    'fib 7' => test_zci(
        'The 7th fibonacci number is 13 (assuming f(0) = 0).',
        structured_answer => {
            input     => ['7th'],
            operation => 'Fibonacci number',
            result    => 13
        }
    ),
    'fibonacci 33' => test_zci(
        'The 33rd fibonacci number is 3524578 (assuming f(0) = 0).',
        structured_answer => {
            input     => ['33rd'],
            operation => 'Fibonacci number',
            result    => 3524578
        }
    ),
    'tell a fib'                  => undef,
    'what are fibonacci numbers?' => undef,
);

done_testing;
