#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "least_common_multiple";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::LeastCommonMultiple )],
    'lcm 9 81' => test_zci(
        'Least common multiple of 9 and 81 is 81.',
        structured_answer => {
            input     => ['9 and 81'],
            operation => 'Least common multiple',
            result    => 81
        }
    ),
    'lowest common multiple 15 25' => test_zci(
        'Least common multiple of 15 and 25 is 75.',
        structured_answer => {
            input     => ['15 and 25'],
            operation => 'Least common multiple',
            result    => 75
        }
    ),
    'LCM 21 7' => test_zci(
        'Least common multiple of 7 and 21 is 21.',
        structured_answer => {
            input     => ['7 and 21'],
            operation => 'Least common multiple',
            result    => 21
        }
    ),
    '24 36 least common multiple' => test_zci(
        'Least common multiple of 24 and 36 is 72.',
        structured_answer => {
            input     => ['24 and 36'],
            operation => 'Least common multiple',
            result    => 72
        }
    ),
    'smallest common multiple 16 24' => test_zci(
        'Least common multiple of 16 and 24 is 48.',
        structured_answer => {
            input     => ['16 and 24'],
            operation => 'Least common multiple',
            result    => 48
        }
    ),
    'lcm 2' => test_zci(
        'Least common multiple of 2 is 2.',
        structured_answer => {
            input     => ['2'],
            operation => 'Least common multiple',
            result    => 2
        }
    ),
    'lcm 12 18 24' => test_zci(
        'Least common multiple of 12, 18 and 24 is 72.',
        structured_answer => {
            input     => ['12, 18 and 24'],
            operation => 'Least common multiple',
            result    => 72
        }
    ),
    'lcm 6, 9, ,,,,     12       15' => test_zci(
        'Least common multiple of 6, 9, 12 and 15 is 180.',
        structured_answer => {
            input     => ['6, 9, 12 and 15'],
            operation => 'Least common multiple',
            result    => 180
        }
    ),
);

done_testing;