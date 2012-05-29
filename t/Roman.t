#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'roman_numeral_conversion';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Roman
        )],
        'roman 155' => test_zci('CLV (roman numeral conversion)'),
        "roman xii" => test_zci("12 (roman numeral conversion)"),
        "roman mmcml" => test_zci("2950 (roman numeral conversion)"),
        "roman 2344" => test_zci("MMCCCXLIV (roman numeral conversion)"),
        "arabic cccxlvi" => test_zci("346 (roman numeral conversion)"),
);

done_testing;
