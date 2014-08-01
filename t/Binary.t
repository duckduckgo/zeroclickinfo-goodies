#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'binary_conversion';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Binary)],
    'foo in binary'        => test_zci('Binary conversion: "foo" (string) = 011001100110111101101111 (binary)'),
    '12 as binary'         => test_zci('Binary conversion: 12 (decimal) = 00001100 (binary)'),
    'that to binary'       => test_zci('Binary conversion: "that" (string) = 01110100011010000110000101110100 (binary)'),
    '127 to binary'        => test_zci('Binary conversion: 127 (decimal) = 01111111 (binary)'),
    '256 to binary'        => test_zci('Binary conversion: 256 (decimal) = 0000000100000000 (binary)'),
    '0x00 to binary'       => test_zci('Binary conversion: 0x00 (hex) = 00000000 (binary)'),
    '0x1e to binary'       => test_zci('Binary conversion: 0x1e (hex) = 00011110 (binary)'),
    'xa1 to binary'        => test_zci('Binary conversion: 0xa1 (hex) = 10100001 (binary)'),
    'ffff to binary'       => test_zci('Binary conversion: 0xffff (hex) = 1111111111111111 (binary)'),
    'hex 0xffff to binary' => test_zci('Binary conversion: 0xffff (hex) = 1111111111111111 (binary)'),
    'FEFE to binary'       => test_zci('Binary conversion: 0xfefe (hex) = 1111111011111110 (binary)'),
    '10 binary'            => test_zci('Binary conversion: 10 (binary) = 2 (decimal)'),
    '10 from binary'       => test_zci('Binary conversion: 10 (binary) = 2 (decimal)'),
    '10 to binary'         => test_zci('Binary conversion: 10 (decimal) = 00001010 (binary)'),
    'decimal 10 as binary' => test_zci('Binary conversion: 10 (decimal) = 00001010 (binary)'),
    'hex 10 into binary'   => test_zci('Binary conversion: 0x10 (hex) = 00010000 (binary)'),
    '0xg into binary'      => test_zci('Binary conversion: "0xg" (string) = 001100000111100001100111 (binary)'),
    'hex 0xg as binary'    => test_zci('Binary conversion: "hex 0xg" (string) = 01101000011001010111100000100000001100000111100001100111 (binary)'),
    '2336462209024 in binary' => test_zci('Binary conversion: 2336462209024 (decimal) = 000000100010000000000000000000000000000000000000 (binary)'),
    '300000000000000 as binary' =>
      test_zci('Binary conversion: 300000000000000 (decimal) = 00000001000100001101100100110001011011101100000000000000 (binary)'),
    'binary 10'            => undef,
    '12 binary'            => undef,
    '12 from binary'       => undef,
    'decimal 12 binary'    => undef,
    'hex 12 binary'        => undef,
    'Cyngus X-1 binary'    => undef,
    'Cygnus X-1 as binary' => test_zci(
        'Binary conversion: "Cygnus X-1" (string) = 01000011011110010110011101101110011101010111001100100000010110000010110100110001 (binary)'),
    'to binary' => undef,
);

done_testing;
