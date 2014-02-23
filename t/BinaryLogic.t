#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'binary_logic';
# zci is_cached => 1;

ddg_goodie_test(
    [qw(
                DDG::Goodie::BinaryLogic
        )],
    '4 xor 5' => test_zci('1'),
    '4 ⊕ 5' => test_zci('1'),

    '9489 xor 394 xor 9349 xor 39 xor 29 xor 4967 xor 3985' => test_zci('7378'),
    #'9489 ⊕ 394 ⊕ 9349 ⊕ 39 ⊕ 29 ⊕ 4967 ⊕ 3985' => test_zci('7378'),

    '10 and 12' => test_zci('8'),
    '10 ∧ 12' => test_zci('8'),

    '52 or 100' => test_zci('116'),
    '52 ∨ 100' => test_zci('116'),

    '23 and (30 or 128)' => test_zci('22'),
    '23 ∧ (30 ∨ 128)' => test_zci('22'),

    '0x999 xor 0x589' => test_zci('3088'),
    '0x999 ⊕ 0x589' => test_zci('3088'),

    'not 1' => test_zci('18446744073709551614'),
    '¬1' => test_zci('18446744073709551614'),
);

done_testing;
