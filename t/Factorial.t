#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use bigint;

zci answer_type => "factorial";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Factorial )],
    'fact 4' => test_zci(
        'Factorial of 4 is 24',
        structured_answer => {
            input     => ['4'],
            operation => 'Factorial',
            result    => 24
        }
    ),
    'factorial 6' => test_zci(
        'Factorial of 6 is 720',
        structured_answer => {
            input     => ['6'],
            operation => 'Factorial',
            result    => 720
        }
    ),
    'factorial 0' => test_zci(
        'Factorial of 0 is 1',
        structured_answer => {
            input     => ['0'],
            operation => 'Factorial',
            result    => 1
        }
    ),
    'tell a factorial'    => undef,
    'what is factorial?' => undef,
    'a factorial' => undef,
    '25abc factorial' => undef,
    'factorial xyz' => undef,
    'factorial -9' => undef,
    'factorial 0!' => undef,
    '-12 factorial' => undef,
    'fact -8' => undef,
    'fact 12!' => undef,
    'abc fact' => undef,
    'n8 fact' => undef,
);

done_testing;
