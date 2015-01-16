#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'lowercase';
zci is_cached   => 1;

ddg_goodie_test(
    ['DDG::Goodie::Lowercase'],
    'lowercase foo' => test_zci(
        'foo',
        structured_answer => {
            input     => ['foo'],
            operation => 'Lowercase',
            result    => 'foo'
        },
    ),
    'lower case foO' => test_zci(
        'foo',
        structured_answer => {
            input     => ['foO'],
            operation => 'Lowercase',
            result    => 'foo'
        },
    ),
    'lowercase john Doe' => test_zci(
        'john doe',
        structured_answer => {
            input     => ['john Doe'],
            operation => 'Lowercase',
            result    => 'john doe'
        },
    ),
    'lowercase GitHub' => test_zci(
        'github',
        structured_answer => {
            input     => ['GitHub'],
            operation => 'Lowercase',
            result    => 'github'
        },
    ),
    'lower case GitHub' => test_zci(
        'github',
        structured_answer => {
            input     => ['GitHub'],
            operation => 'Lowercase',
            result    => 'github'
        },
    ),
    'lc GitHub' => test_zci(
        'github',
        structured_answer => {
            input     => ['GitHub'],
            operation => 'Lowercase',
            result    => 'github'
        },
    ),
    'strtolower GitHub' => test_zci(
        'github',
        structured_answer => {
            input     => ['GitHub'],
            operation => 'Lowercase',
            result    => 'github'
        },
    ),
    'tolower GitHub' => test_zci(
        'github',
        structured_answer => {
            input     => ['GitHub'],
            operation => 'Lowercase',
            result    => 'github'
        },
    ),
    'how to lowercase text' => undef
);

done_testing;
