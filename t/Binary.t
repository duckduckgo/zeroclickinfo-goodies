#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'binary_conversion';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Binary)],
    'foo in binary' => test_zci(
        'Binary conversion: foo (String) = 011001100110111101101111 (Binary)',
        structured_answer => {
            input     => ['foo'],
            operation => 'String to Binary',
            result    => '011001100110111101101111'
        }
    ),
    '12 as binary' => test_zci(
        'Binary conversion: 12 (Decimal) = 00001100 (Binary)',
        structured_answer => {
            input     => [12],
            operation => 'Decimal to Binary',
            result    => '00001100'
        }
    ),
    'that to binary' => test_zci(
        'Binary conversion: that (String) = 01110100011010000110000101110100 (Binary)',
        structured_answer => {
            input     => ['that'],
            operation => 'String to Binary',
            result    => '01110100011010000110000101110100'
        }
    ),
    '127 to binary' => test_zci(
        'Binary conversion: 127 (Decimal) = 01111111 (Binary)',
        structured_answer => {
            input     => ['127'],
            operation => 'Decimal to Binary',
            result    => '01111111'
        }
    ),
    '256 to binary' => test_zci(
        'Binary conversion: 256 (Decimal) = 0000000100000000 (Binary)',
        structured_answer => {
            input     => ['256'],
            operation => 'Decimal to Binary',
            result    => '0000000100000000'
        }
    ),
    '0x00 to binary' => test_zci(
        'Binary conversion: 0x00 (Hex) = 00000000 (Binary)',
        structured_answer => {
            input     => ['0x00'],
            operation => 'Hex to Binary',
            result    => '00000000'
        }
    ),
    '0x1e to binary' => test_zci(
        'Binary conversion: 0x1e (Hex) = 00011110 (Binary)',
        structured_answer => {
            input     => ['0x1e'],
            operation => 'Hex to Binary',
            result    => '00011110'
        }
    ),
    'xa1 to binary' => test_zci(
        'Binary conversion: 0xa1 (Hex) = 10100001 (Binary)',
        structured_answer => {
            input     => ['0xa1'],
            operation => 'Hex to Binary',
            result    => '10100001'
        }
    ),
    'ffff to binary' => test_zci(
        'Binary conversion: 0xffff (Hex) = 1111111111111111 (Binary)',
        structured_answer => {
            input     => ['0xffff'],
            operation => 'Hex to Binary',
            result    => '1111111111111111'
        }
    ),
    'hex 0xffff to binary' => test_zci(
        'Binary conversion: 0xffff (Hex) = 1111111111111111 (Binary)',
        structured_answer => {
            input     => ['0xffff'],
            operation => 'Hex to Binary',
            result    => '1111111111111111'
        }
    ),
    'FEFE to binary' => test_zci(
        'Binary conversion: 0xfefe (Hex) = 1111111011111110 (Binary)',
        structured_answer => {
            input     => ['0xfefe'],
            operation => 'Hex to Binary',
            result    => '1111111011111110'
        }
    ),
    '10 binary' => test_zci(
        'Binary conversion: 10 (Binary) = 2 (Decimal)',
        structured_answer => {
            input     => ['10'],
            operation => 'Binary to Decimal',
            result    => '2'
        }
    ),
    '10 from binary' => test_zci(
        'Binary conversion: 10 (Binary) = 2 (Decimal)',
        structured_answer => {
            input     => ['10'],
            operation => 'Binary to Decimal',
            result    => '2'
        }
    ),
    '10 to binary' => test_zci(
        'Binary conversion: 10 (Decimal) = 00001010 (Binary)',
        structured_answer => {
            input     => ['10'],
            operation => 'Decimal to Binary',
            result    => '00001010'
        }
    ),
    'decimal 10 as binary' => test_zci(
        'Binary conversion: 10 (Decimal) = 00001010 (Binary)',
        structured_answer => {
            input     => ['10'],
            operation => 'Decimal to Binary',
            result    => '00001010'
        }
    ),
    'hex 10 into binary' => test_zci(
        'Binary conversion: 0x10 (Hex) = 00010000 (Binary)',
        structured_answer => {
            input     => ['0x10'],
            operation => 'Hex to Binary',
            result    => '00010000'
        }
    ),
    '0xg into binary' => test_zci(
        'Binary conversion: 0xg (String) = 001100000111100001100111 (Binary)',
        structured_answer => {
            input     => ['0xg'],
            operation => 'String to Binary',
            result    => '001100000111100001100111'
        }
    ),
    'hex 0xg as binary' => test_zci(
        'Binary conversion: hex 0xg (String) = 01101000011001010111100000100000001100000111100001100111 (Binary)',
        structured_answer => {
            input     => ['hex 0xg'],
            operation => 'String to Binary',
            result    => '01101000011001010111100000100000001100000111100001100111'
        }
    ),
    '2336462209024 in binary' => test_zci(
        'Binary conversion: 2336462209024 (Decimal) = 000000100010000000000000000000000000000000000000 (Binary)',
        structured_answer => {
            input     => ['2336462209024'],
            operation => 'Decimal to Binary',
            result    => '000000100010000000000000000000000000000000000000'
        }
    ),
    '300000000000000 as binary' => test_zci(
        'Binary conversion: 300000000000000 (Decimal) = 00000001000100001101100100110001011011101100000000000000 (Binary)',
        structured_answer => {
            input     => [300000000000000],
            operation => 'Decimal to Binary',
            result    => '00000001000100001101100100110001011011101100000000000000'
        }
    ),
    'Cygnus X-1 as binary' => test_zci(
        'Binary conversion: Cygnus X-1 (String) = 01000011011110010110011101101110011101010111001100100000010110000010110100110001 (Binary)',
        structured_answer => {
            input     => ['Cygnus X-1'],
            operation => 'String to Binary',
            result    => '01000011011110010110011101101110011101010111001100100000010110000010110100110001'
        }
    ),
    'binary 10'         => undef,
    '12 binary'         => undef,
    '12 from binary'    => undef,
    'decimal 12 binary' => undef,
    'hex 12 binary'     => undef,
    'Cyngus X-1 binary' => undef,
    'to binary'         => undef,
);

done_testing;
