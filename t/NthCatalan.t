#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "nth_catalan";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::NthCatalan )],
    'catalan 7' => test_zci(
        'The 7th catalan number is 429.',
        structured_answer => {
            input     => ['7th'],
            operation => 'Catalan number',
            result    => 429
        }
    ),
    '30th catalan number' => test_zci(
        'The 30th catalan number is 3814986502092304.',
        structured_answer => {
            input     => ['30th'],
            operation => 'Catalan number',
            result    => 3814986502092304
        }
    ),
    'tell a catalan number' => undef,
    'what are catalan numbers?' => undef,
);

done_testing;
