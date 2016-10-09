#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'atbash';
zci is_cached   => 1;



ddg_goodie_test(
    [qw( DDG::Goodie::Atbash )],
    'atbash test' => test_zci(
        'Atbash: gvhg',
        structured_answer => {
            data => {
                title => "gvhg",
                subtitle => "Atbash: test"
            },
            templates => {
                group => 'text',
                moreAt => 0
            }
        }
    ),
    'atbash This is a test' => test_zci(
        'Atbash: Gsrh rh z gvhg',
        structured_answer => {
            data => {
                title => "Gsrh rh z gvhg",
                subtitle => "Atbash: This is a test"
            },
            templates => {
                group => 'text',
                moreAt => 0
            }
        }
    ),
    "atbash Gonna party like it's 1999!" => test_zci(
        "Atbash: Tlmmz kzigb orpv rg'h 1999!",
        structured_answer => {
            data => {
                title => "Tlmmz kzigb orpv rg'h 1999!",
                subtitle => "Atbash: Gonna party like it's 1999!"
            },
            templates => {
                group => 'text',
                moreAt => 0
            }
        }
    ),
    'Atbash abcdefghijklmnopqrstuvwxyz' => test_zci(
        'Atbash: zyxwvutsrqponmlkjihgfedcba',
        structured_answer => {
            data => {
                title => "zyxwvutsrqponmlkjihgfedcba",
                subtitle => "Atbash: abcdefghijklmnopqrstuvwxyz"
            },
            templates => {
                group => 'text',
                moreAt => 0
            }
        }
    ),
    'atbash hello' => test_zci(
        'Atbash: svool',
        structured_answer => {
            data => {
                title => "svool",
                subtitle => "Atbash: hello"
            },
            templates => {
                group => 'text',
                moreAt => 0
            }
        }
    ),
    'atbash svool' => test_zci(
        'Atbash: hello',
        structured_answer => {
            data => {
                title => "hello",
                subtitle => "Atbash: svool"
            },
            templates => {
                group => 'text',
                moreAt => 0
            }
        }
    ),
);

done_testing;
