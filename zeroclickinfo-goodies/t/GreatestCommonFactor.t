#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "greatest_common_factor";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::GreatestCommonFactor )],
    'gcf 9 81' => test_zci(
        'Greatest common factor of 9 and 81 is 9.',
        structured_answer => {
            input     => ['9 and 81'],
            operation => 'Greatest common factor',
            result    => 9
        }
    ),
    '1000 100 greatest common factor' => test_zci(
        'Greatest common factor of 100 and 1000 is 100.',
        structured_answer => {
            input     => ['100 and 1000'],
            operation => 'Greatest common factor',
            result    => 100
        }
    ),
    'GCF 12 76' => test_zci(
        'Greatest common factor of 12 and 76 is 4.',
        structured_answer => {
            input     => ['12 and 76'],
            operation => 'Greatest common factor',
            result    => 4
        }
    ),
    'GCF 121 11' => test_zci(
        'Greatest common factor of 11 and 121 is 11.',
        structured_answer => {
            input     => ['11 and 121'],
            operation => 'Greatest common factor',
            result    => 11
        }
    ),
    '99 9 greatest common factor' => test_zci(
        'Greatest common factor of 9 and 99 is 9.',
        structured_answer => {
            input     => ['9 and 99'],
            operation => 'Greatest common factor',
            result    => 9
        }
    ),
    'greatest common divisor 4 6' => test_zci(
        'Greatest common factor of 4 and 6 is 2.',
        structured_answer => {
            input     => ['4 and 6'],
            operation => 'Greatest common factor',
            result    => 2
        }
    ),
    'gcd 4 6' => test_zci(
        'Greatest common factor of 4 and 6 is 2.',
        structured_answer => {
            input     => ['4 and 6'],
            operation => 'Greatest common factor',
            result    => 2
        }
    ),
    'gcd 2' => test_zci(
        'Greatest common factor of 2 is 2.',
        structured_answer => {
            input     => ['2'],
            operation => 'Greatest common factor',
            result    => 2
        }
    ),
    'gcd 12 18 24' => test_zci(
        'Greatest common factor of 12, 18 and 24 is 6.',
        structured_answer => {
            input     => ['12, 18 and 24'],
            operation => 'Greatest common factor',
            result    => 6
        }
    ),
    'gcd 25 20 15 10 5' => test_zci(
        'Greatest common factor of 5, 10, 15, 20 and 25 is 5.',
        structured_answer => {
            input     => ['5, 10, 15, 20 and 25'],
            operation => 'Greatest common factor',
            result    => 5
        }
    ),
    'gcd 6, 9, ,,,,     12       15' => test_zci(
        'Greatest common factor of 6, 9, 12 and 15 is 3.',
        structured_answer => {
            input     => ['6, 9, 12 and 15'],
            operation => 'Greatest common factor',
            result    => 3
        }
    ),
    'gcd 2 3' => test_zci(
        'Greatest common factor of 2 and 3 is 1.',
        structured_answer => {
            input     => ['2 and 3'],
            operation => 'Greatest common factor',
            result    => 1
        }
    ),
    'gcd 2 3 5' => test_zci(
        'Greatest common factor of 2, 3 and 5 is 1.',
        structured_answer => {
            input     => ['2, 3 and 5'],
            operation => 'Greatest common factor',
            result    => 1
        }
    ),
    'gcd 0 2' => test_zci(
        'Greatest common factor of 0 and 2 is 2.',
        structured_answer => {
            input     => ['0 and 2'],
            operation => 'Greatest common factor',
            result    => 2
        }
    ),
    'gcd 0 0' => test_zci(
        'Greatest common factor of 0 and 0 is 0.',
        structured_answer => {
            input     => ['0 and 0'],
            operation => 'Greatest common factor',
            result    => 0
        }
    ),
);

done_testing;
