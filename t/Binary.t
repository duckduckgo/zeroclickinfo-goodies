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
        'Binary conversion: foo (string) = 011001100110111101101111 (binary)',
        structured_answer => {
            input     => ['foo'],
            operation => 'string to binary',
            result    => '011001100110111101101111'
        }
    ),
    '12 as binary' => test_zci(
        'Binary conversion: 12 (decimal) = 00001100 (binary)',
        structured_answer => {
            input     => [12],
            operation => 'decimal to binary',
            result    => '00001100'
        }
    ),
    'that to binary' => test_zci(
        'Binary conversion: that (string) = 01110100011010000110000101110100 (binary)',
        structured_answer => {
            input     => ['that'],
            operation => 'string to binary',
            result    => '01110100011010000110000101110100'
        }
    ),
    '127 to binary' => test_zci(
        'Binary conversion: 127 (decimal) = 01111111 (binary)',
        structured_answer => {
            input     => ['127'],
            operation => 'decimal to binary',
            result    => '01111111'
        }
    ),
    '256 to binary' => test_zci(
        'Binary conversion: 256 (decimal) = 0000000100000000 (binary)',
        structured_answer => {
            input     => ['256'],
            operation => 'decimal to binary',
            result    => '0000000100000000'
        }
    ),
    '0x00 to binary' => test_zci(
        'Binary conversion: 0x00 (hex) = 00000000 (binary)',
        structured_answer => {
            input     => ['0x00'],
            operation => 'hex to binary',
            result    => '00000000'
        }
    ),
    '0x1e to binary' => test_zci(
        'Binary conversion: 0x1e (hex) = 00011110 (binary)',
        structured_answer => {
            input     => ['0x1e'],
            operation => 'hex to binary',
            result    => '00011110'
        }
    ),
    'xa1 to binary' => test_zci(
        'Binary conversion: 0xa1 (hex) = 10100001 (binary)',
        structured_answer => {
            input     => ['0xa1'],
            operation => 'hex to binary',
            result    => '10100001'
        }
    ),
    'ffff to binary' => test_zci(
        'Binary conversion: 0xffff (hex) = 1111111111111111 (binary)',
        structured_answer => {
            input     => ['0xffff'],
            operation => 'hex to binary',
            result    => '1111111111111111'
        }
    ),
    'hex 0xffff to binary' => test_zci(
        'Binary conversion: 0xffff (hex) = 1111111111111111 (binary)',
        structured_answer => {
            input     => ['0xffff'],
            operation => 'hex to binary',
            result    => '1111111111111111'
        }
    ),
    'FEFE to binary' => test_zci(
        'Binary conversion: 0xfefe (hex) = 1111111011111110 (binary)',
        structured_answer => {
            input     => ['0xfefe'],
            operation => 'hex to binary',
            result    => '1111111011111110'
        }
    ),
    '10 binary' => test_zci(
        'Binary conversion: 10 (binary) = 2 (decimal)',
        structured_answer => {
            input     => ['10'],
            operation => 'binary to decimal',
            result    => '2'
        }
    ),
    '10 from binary' => test_zci(
        'Binary conversion: 10 (binary) = 2 (decimal)',
        structured_answer => {
            input     => ['10'],
            operation => 'binary to decimal',
            result    => '2'
        }
    ),
    '10 to binary' => test_zci(
        'Binary conversion: 10 (decimal) = 00001010 (binary)',
        structured_answer => {
            input     => ['10'],
            operation => 'decimal to binary',
            result    => '00001010'
        }
    ),
    'decimal 10 as binary' => test_zci(
        'Binary conversion: 10 (decimal) = 00001010 (binary)',
        structured_answer => {
            input     => ['10'],
            operation => 'decimal to binary',
            result    => '00001010'
        }
    ),
    'hex 10 into binary' => test_zci(
        'Binary conversion: 0x10 (hex) = 00010000 (binary)',
        structured_answer => {
            input     => ['0x10'],
            operation => 'hex to binary',
            result    => '00010000'
        }
    ),
    '0xg into binary' => test_zci(
        'Binary conversion: 0xg (string) = 001100000111100001100111 (binary)',
        structured_answer => {
            input     => ['0xg'],
            operation => 'string to binary',
            result    => '001100000111100001100111'
        }
    ),
    'hex 0xg as binary' => test_zci(
        'Binary conversion: hex 0xg (string) = 01101000011001010111100000100000001100000111100001100111 (binary)',
        structured_answer => {
            input     => ['hex 0xg'],
            operation => 'string to binary',
            result    => '01101000011001010111100000100000001100000111100001100111'
        }
    ),
    '2336462209024 in binary' => test_zci(
        'Binary conversion: 2336462209024 (decimal) = 000000100010000000000000000000000000000000000000 (binary)',
        structured_answer => {
            input     => ['2336462209024'],
            operation => 'decimal to binary',
            result    => '000000100010000000000000000000000000000000000000'
        }
    ),
    '300000000000000 as binary' => test_zci(
        'Binary conversion: 300000000000000 (decimal) = 00000001000100001101100100110001011011101100000000000000 (binary)',
        structured_answer => {
            input     => [300000000000000],
            operation => 'decimal to binary',
            result    => '00000001000100001101100100110001011011101100000000000000'
        }
    ),
    'Cygnus X-1 as binary' => test_zci(
        'Binary conversion: Cygnus X-1 (string) = 01000011011110010110011101101110011101010111001100100000010110000010110100110001 (binary)',
        structured_answer => {
            input     => ['Cygnus X-1'],
            operation => 'string to binary',
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
