#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'binary_conversion';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Binary
        )],
        'this in binary' => test_zci('"this" as a string is 01110100011010000110100101110011 in binary.'),
        'that to binary' => test_zci('"that" as a string is 01110100011010000110000101110100 in binary.'),
        '127 to binary' => test_zci('01111111'),
        '128 to binary' => test_zci('10000000'),
        '255 to binary' => test_zci('11111111'),
        '256 to binary' => test_zci('0000000100000000'),
        '0x00 to binary' => test_zci('00000000'),
        'Ox1e to binary' => test_zci('00011110'),
        'xa1 to binary'  => test_zci('10100001'),
        'ffff to binary' => test_zci('1111111111111111'),
        'FEFE to binary' => test_zci('1111111011111110'),
        '0 to binary' => test_zci('00000000')
);

done_testing;
