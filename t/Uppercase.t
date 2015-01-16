#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'uppercase';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Uppercase)],
    'upper case this' => test_zci(
        'THIS',
        structured_answer => {
            input     => ['this'],
            operation => 'Uppercase',
            result    => 'THIS'
        }
    ),
    'uppercase that' => test_zci(
        'THAT',
        structured_answer => {
            input     => ['that'],
            operation => 'Uppercase',
            result    => 'THAT'
        }
    ),
    'allcaps this string' => test_zci(
        'THIS STRING',
        structured_answer => {
            input     => ['this string'],
            operation => 'Uppercase',
            result    => 'THIS STRING'
        }
    ),
    'that string all caps'    => undef,
    'is this uppercase, sir?' => undef,
);

done_testing;
