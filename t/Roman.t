#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'roman_numeral_conversion';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Roman )],
    'roman 155' => test_zci(
        'CLV (roman numeral conversion)',
        structured_answer => {
            input     => ['155'],
            operation => 'Roman numeral conversion',
            result    => 'CLV'
        }
    ),
    "roman xii" => test_zci(
        "12 (roman numeral conversion)",
        structured_answer => {
            input     => ['XII'],
            operation => 'Roman numeral conversion',
            result    => '12'
        }
    ),
    "roman mmcml" => test_zci(
        "2950 (roman numeral conversion)",
        structured_answer => {
            input     => ['MMCML'],
            operation => 'Roman numeral conversion',
            result    => '2950'
        }
    ),
    "roman 2344" => test_zci(
        "MMCCCXLIV (roman numeral conversion)",
        structured_answer => {
            input     => ['2344'],
            operation => 'Roman numeral conversion',
            result    => 'MMCCCXLIV'
        }
    ),
    "arabic cccxlvi" => test_zci(
        "346 (roman numeral conversion)",
        structured_answer => {
            input     => ['CCCXLVI'],
            operation => 'Roman numeral conversion',
            result    => '346'
        }
    ),
    'roman numeral MCCCXXXVII' => test_zci(
        '1337 (roman numeral conversion)',
        structured_answer => {
            input     => ['MCCCXXXVII'],
            operation => 'Roman numeral conversion',
            result    => '1337'
        }
    ),
    'roman 1337' => test_zci(
        'MCCCXXXVII (roman numeral conversion)',
        structured_answer => {
            input     => ['1337'],
            operation => 'Roman numeral conversion',
            result    => 'MCCCXXXVII'
        }
    ),
    'roman IV' => test_zci(
        '4 (roman numeral conversion)',
        structured_answer => {
            input     => ['IV'],
            operation => 'Roman numeral conversion',
            result    => '4'
        }
    ),
);

done_testing;
