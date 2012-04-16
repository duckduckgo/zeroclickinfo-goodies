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
	'0 1 2 3 to binary' => test_zci('00000000 00000001 00000010 00000011'),
	'1,1,2,3,5,8 to binary' => test_zci('00000001 00000001 00000010 00000011 00000101 00001000'),
	'0, 1; 2: 3| to binary' => test_zci('00000000 00000001 00000010 00000011'),
        '0x00 to binary' => test_zci('00000000'),
        'Ox1e to binary' => test_zci('00011110'),
        'ox321 to binary' => test_zci('0000001100100001'),
        'xa1 to binary'  => test_zci('10100001'),
        'ffff to binary' => test_zci('1111111111111111'),
        'FEFE to binary' => test_zci('1111111011111110'),
	'ff|ea;eb  ec:,, to binary' => test_zci('11111111 11101010 11101011 11101100'),
        '0 to binary' => test_zci('00000000')
);

done_testing;
