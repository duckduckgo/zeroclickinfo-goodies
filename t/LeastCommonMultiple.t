#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
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
            result    => 81,
            name => 'Math',
            id=>'least_common_multiple',
            
            data => {
                title    => 81,
                subtitle => "Least common multiple of 9 and 81",
            },

            templates => {
                group => "text"
            }
        }
    ),
    'lowest common multiple 81 and 9' => test_zci(
        'Least common multiple of 81 and 9 is 81.',
        structured_answer => {
            input     => ['81 and 9'],
            operation => 'Least common multiple',
            result    => 81,
            name => 'Math',
            id=>'least_common_multiple',
            
            data => {
                title    => 81,
                subtitle => "Least common multiple of 81 and 9",
            },

            templates => {
                group => "text"
            }
        }
    ),
    '3, 5, 2 least common multiple' => test_zci(
        'Least common multiple of 3, 5 and 2 is 30.',
        structured_answer => {
            input     => ['3, 5 and 2'],
            operation => 'Least common multiple',
            result    => 30,
            name => 'Math',
            id=>'least_common_multiple',
            
            data => {
                title    => 30,
                subtitle => "Least common multiple of 3, 5 and 2",
            },

            templates => {
                group => "text"
            }
        }
    ),
    'lcm 9' => test_zci(
        'Least common multiple of 9 is 9.',
        structured_answer => {
            input     => ['9'],
            operation => 'Least common multiple',
            result    => 9,
            name => 'Math',
            id=>'least_common_multiple',
            
            data => {
                title    => 9,
                subtitle => "Least common multiple of 9",
            },

            templates => {
                group => "text"
            }
        }
    ),
    'LCM 3 and 5 and 10 and 2' => test_zci(
        'Least common multiple of 3, 5, 10 and 2 is 30.',
        structured_answer => {
            input     => ['3, 5, 10 and 2'],
            operation => 'Least common multiple',
            result    => 30,
            name => 'Math',
            id=>'least_common_multiple',
            
            data => {
                title    => 30,
                subtitle => "Least common multiple of 3, 5, 10 and 2",
            },

            templates => {
                group => "text"
            }
        }
    ),
    'lcm' => undef,
    '3,5,10,2 lcm' => test_zci(
        'Least common multiple of 3, 5, 10 and 2 is 30.',
        structured_answer => {
            input     => ['3, 5, 10 and 2'],
            operation => 'Least common multiple',
            result    => 30,
            name => 'Math',
            id=>'least_common_multiple',
            
            data => {
                title    => 30,
                subtitle => "Least common multiple of 3, 5, 10 and 2",
            },

            templates => {
                group => "text"
            }
        }
    ),
    
);

done_testing;
