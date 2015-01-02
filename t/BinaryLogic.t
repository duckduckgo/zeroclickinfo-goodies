#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'binary_logic';
zci is_cached => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::BinaryLogic
    )],
    '4 xor 5' => test_zci('1',
        html => "<div>Result: <b>1</b></div>",
        heading => "Binary Logic"
    ),
    '4 ⊕ 5' => test_zci('1',
        html => "<div>Result: <b>1</b></div>",
        heading => "Binary Logic"
    ),
    '9489 xor 394 xor 9349 xor 39 xor 29 xor 4967 xor 3985' => test_zci('7378',
        html => "<div>Result: <b>7378</b></div>",
        heading => "Binary Logic"
    ),
    '10 and 12' => test_zci('8',
        html => "<div>Result: <b>8</b></div>",
        heading => "Binary Logic"
    ),
    '10 ∧ 12' => test_zci('8',
        html => "<div>Result: <b>8</b></div>",
        heading => "Binary Logic"
    ),
    '52 or 100' => test_zci('116',
        html => "<div>Result: <b>116</b></div>",
        heading => "Binary Logic"
    ),
    '52 ∨ 100' => test_zci('116',
        html => "<div>Result: <b>116</b></div>",
        heading => "Binary Logic"
    ),
    '23 and (30 or 128)' => test_zci('22',
        html => "<div>Result: <b>22</b></div>",
        heading => "Binary Logic"
    ),
    '23 ∧ (30 ∨ 128)' => test_zci('22',
        html => "<div>Result: <b>22</b></div>",
        heading => "Binary Logic"
    ),
    '0x999 xor 0x589' => test_zci('3088',
        html => "<div>Result: <b>3088</b></div>",
        heading => "Binary Logic"
    ),
    '0x999 ⊕ 0x589' => test_zci('3088',
        html => "<div>Result: <b>3088</b></div>",
        heading => "Binary Logic"
    ),
    'not 1' => test_zci('18446744073709551614',
        html => "<div>Result: <b>18446744073709551614</b></div>",
        heading => "Binary Logic"
    ),
    '¬1' => test_zci('18446744073709551614',
        html => "<div>Result: <b>18446744073709551614</b></div>",
        heading => "Binary Logic"
    ),
    '3 and 2' => test_zci('2',
        html => "<div>Result: <b>2</b></div>",
        heading => "Binary Logic"
    ),
    '1 or 1234' => test_zci('1235',
        html => "<div>Result: <b>1235</b></div>",
        heading => "Binary Logic"
    ),
    '34 or 100' => test_zci('102',
        html => "<div>Result: <b>102</b></div>",
        heading => "Binary Logic"
    ),
    '10 and (30 or 128)' => test_zci('10',
        html => "<div>Result: <b>10</b></div>",
        heading => "Binary Logic"
    ),
    '0x01 or not 0X100' => test_zci('18446744073709551359',
        html => "<div>Result: <b>18446744073709551359</b></div>",
        heading => "Binary Logic"
    ),
    '0x01 or 0x02' => test_zci('3',
        html => "<div>Result: <b>3</b></div>",
        heading => "Binary Logic"
    ),
    '0b01 or 0b10' => test_zci('3',
        html => "<div>Result: <b>3</b></div>",
        heading => "Binary Logic"
    ),
    '0B11 xor 0B10' => test_zci('1',
        html => "<div>Result: <b>1</b></div>",
        heading => "Binary Logic"
    ),
);

done_testing;