#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'atbash';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Atbash )],
    'atbash test' => test_zci(
        'Atbash: gvhg',
        structured_answer => {
            input     => ['test'],
            operation => 'Atbash',
            result    => 'gvhg'
        },
    ),
    'atbash This is a test' => test_zci(
        'Atbash: Gsrh rh z gvhg',
        structured_answer => {
            input     => ['This is a test'],
            operation => 'Atbash',
            result    => 'Gsrh rh z gvhg'
        },
    ),
    'atbash Gonna party like it\'s 1999!' => test_zci(
        'Atbash: Tlmmz kzigb orpv rg\'h 1999!',
        structured_answer => {
            input     => ['Gonna party like it&#39;s 1999!'],
            operation => 'Atbash',
            result    => 'Tlmmz kzigb orpv rg&#39;h 1999!'
        },
    ),
    'Atbash abcdefghijklmnopqrstuvwxyz' => test_zci(
        'Atbash: zyxwvutsrqponmlkjihgfedcba',
        structured_answer => {
            input     => ['abcdefghijklmnopqrstuvwxyz'],
            operation => 'Atbash',
            result    => 'zyxwvutsrqponmlkjihgfedcba'
        },
    ),
    'atbash hello' => test_zci(
        'Atbash: svool',
        structured_answer => {
            input     => ['hello'],
            operation => 'Atbash',
            result    => 'svool'
        },
    ),
    'atbash svool' => test_zci(
        'Atbash: hello',
        structured_answer => {
            input     => ['svool'],
            operation => 'Atbash',
            result    => 'hello'
        },
    ),
);

done_testing;
