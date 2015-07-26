#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "factorial";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Factorial )],
    'fact 4' => test_zci(
        'Factorial of 4 is 24.',
        structured_answer => {
            input     => ['4'],
            operation => 'Factorial',
            result    => 24
        }
    ),
    'factorial 6' => test_zci(
        'Factorial of 6 is 720.',
        structured_answer => {
            input     => ['6'],
            operation => 'Factorial',
            result    => 720
        }
    ),
    'tell a factorial'    => undef,
    'what is factorial?' => undef,
);

done_testing;
