#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'xor';
zci is_cached => 1;

ddg_goodie_test(
    [qw(
                DDG::Goodie::Xor
        )],
    '4 xor 5' => test_zci('1'),
    '5 ⊕ 79' => test_zci('74'),
    '9489 xor 394 xor 9349 xor 39 xor 29 xor 4967 xor 3985' => test_zci('7378'),
    '10 and 12' => test_zci('8'),
    '52 or 100' => test_zci('116'),
    '23 and (30 or 128)' => test_zci('22'),
    '12 ∧ 23' => test_zci('4'),
    '4567 ∨ 2311' => test_zci('6615'),
    '0x999 xor 0x589' => test_zci('3088'),
    '0b0010 or 0b0001' => test_zci('3')
);

done_testing;
