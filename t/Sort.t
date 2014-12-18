#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'sort';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Sort)],
    'sort -1, +4, -3, 5.7' => test_zci(
        '-3, -1, 4, 5.7 (Sorted ascendingly)',
        structured_answer => {
            input     => ['-1, 4, -3, 5.7'],
            operation => 'sort ascendingly',
            result    => '-3, -1, 4, 5.7'
        }
    ),
    'sort [-1, +4, -3, 5.7]' => test_zci(
        '-3, -1, 4, 5.7 (Sorted ascendingly)',
        structured_answer => {
            input     => ['-1, 4, -3, 5.7'],
            operation => 'sort ascendingly',
            result    => '-3, -1, 4, 5.7'
        }
    ),
    'sort (-1, +4, -3, 5.7)' => test_zci(
        '-3, -1, 4, 5.7 (Sorted ascendingly)',
        structured_answer => {
            input     => ['-1, 4, -3, 5.7'],
            operation => 'sort ascendingly',
            result    => '-3, -1, 4, 5.7'
        }
    ),
    'sort desc -4.4 .5 1 66 15 -55' => test_zci(
        '66, 15, 1, 0.5, -4.4, -55 (Sorted descendingly)',
        structured_answer => {
            input     => ['-4.4, 0.5, 1, 66, 15, -55'],
            operation => 'sort descendingly',
            result    => '66, 15, 1, 0.5, -4.4, -55'
        }
    ),
    'sort desc -4.4 .5 1 66 2e-3 15 -55' => test_zci(
        '66, 15, 1, 0.5, 0.002, -4.4, -55 (Sorted descendingly)',
        structured_answer => {
            input     => ['-4.4, 0.5, 1, 66, 0.002, 15, -55'],
            operation => 'sort descendingly',
            result    => '66, 15, 1, 0.5, 0.002, -4.4, -55'
        }
    ),
    'sort -3 -10 56 10' => test_zci(
        '-10, -3, 10, 56 (Sorted ascendingly)',
        structured_answer => {
            input     => ['-3, -10, 56, 10'],
            operation => 'sort ascendingly',
            result    => '-10, -3, 10, 56'
        }
    ),
    'sort descending 10, -1, +5.3, -95, 1' => test_zci(
        '10, 5.3, 1, -1, -95 (Sorted descendingly)',
        structured_answer => {
            input     => ['10, -1, 5.3, -95, 1'],
            operation => 'sort descendingly',
            result    => '10, 5.3, 1, -1, -95'
        }
    ),
    'sort descending 10, -1, +5.3, -95, 1, 1e2' => test_zci(
        '100, 10, 5.3, 1, -1, -95 (Sorted descendingly)',
        structured_answer => {
            input     => ['10, -1, 5.3, -95, 1, 100'],
            operation => 'sort descendingly',
            result    => '100, 10, 5.3, 1, -1, -95'
        }
    ),
    'sort algorithm'      => undef,
    'sort 1 fish, 2 fish' => undef,
);

done_testing;
