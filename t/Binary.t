#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'binary_conversion';
zci is_cached   => 1;

sub build_structured_answer {
    my ($input, $from, $to, $result) = @_;
    return qq/Binary conversion: $input ($from) = $result ($to)/,
        structured_answer => {
            data => {
              title => $result,
              subtitle =>$from . ' to ' . $to . ': ' . $input
            },
            templates => {
              group => 'text'
            }
    };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Binary)],
    'foo in binary'             => build_test('foo', 'String (UTF-8)', 'Binary', '011001100110111101101111'),
    '12 as binary'              => build_test('12', 'Decimal', 'Binary', '00001100'),
    'that to binary'            => build_test('that', 'String (UTF-8)', 'Binary', '01110100011010000110000101110100'),
    '127 to binary'             => build_test('127', 'Decimal', 'Binary', '01111111'),
    '256 to binary'             => build_test('256', 'Decimal', 'Binary', '0000000100000000'),
    '0x00 to binary'            => build_test('0x00', 'Hex', 'Binary', '00000000'),
    '0x1e to binary'            => build_test('0x1e', 'Hex', 'Binary', '00011110'),
    'xa1 to binary'             => build_test('0xa1', 'Hex', 'Binary', '10100001'),
    'ffff to binary'            => build_test('0xffff', 'Hex', 'Binary', '1111111111111111'),
    'hex 0xffff to binary'      => build_test('0xffff', 'Hex', 'Binary', '1111111111111111'),
    'FEFE to binary'            => build_test('0xfefe', 'Hex', 'Binary', '1111111011111110'),
    '10 binary'                 => build_test('10', 'Binary', 'Decimal', '2'),
    '10 from binary'            => build_test('10', 'Binary', 'Decimal', '2'),
    '10 to binary'              => build_test('10', 'Decimal', 'Binary', '00001010'),
    'decimal 10 as binary'      => build_test('10', 'Decimal', 'Binary', '00001010'),
    'hex 10 into binary'        => build_test('0x10', 'Hex', 'Binary', '00010000'),
    '0xg into binary'           => build_test('0xg', 'String (UTF-8)', 'Binary', '001100000111100001100111'),
    'hex 0xg as binary'         => build_test('hex 0xg', 'String (UTF-8)', 'Binary', '01101000011001010111100000100000001100000111100001100111'),
    '2336462209024 in binary'   => build_test('2336462209024', 'Decimal', 'Binary', '000000100010000000000000000000000000000000000000'),
    '300000000000000 as binary' => build_test(300000000000000, 'Decimal', 'Binary', '00000001000100001101100100110001011011101100000000000000'),
    'Cygnus X-1 as binary'      => build_test('Cygnus X-1', 'String (UTF-8)', 'Binary', '01000011011110010110011101101110011101010111001100100000010110000010110100110001'),
    'è in binary'               => build_test('è', 'String (UTF-8)', 'Binary', '1100001110101000'),
    'ج in binary'               => build_test('ج', 'String (UTF-8)', 'Binary', '1101100010101100'), # Arabic Letter JEEM
    'П in binary'               => build_test('П', 'String (UTF-8)', 'Binary', '1101000010011111'), # Cyrillic Capital Letter PE
    '한글 in binary'             => build_test('한글', 'String (UTF-8)', 'Binary', '111011011001010110011100111010101011100010000000'), # Korean Hangul
    '漢字 in binary'            => build_test('漢字', 'String (UTF-8)', 'Binary', '111001101011110010100010111001011010110110010111'), # Japanese Kanji
    '造字 in binary'            => build_test('造字', 'String (UTF-8)', 'Binary', '111010011000000010100000111001011010110110010111'), # Simplified Chinese
    '扩展 in binary'            => build_test('扩展', 'String (UTF-8)', 'Binary', '111001101000100110101001111001011011000110010101'), # Traditional Chinese
    '🦆 in binary'              => build_test('🦆', 'String (UTF-8)', 'Binary', '11110000100111111010011010000110'), # Emoji
    'binary 10'         => undef,
    '12 binary'         => undef,
    '12 from binary'    => undef,
    'decimal 12 binary' => undef,
    'hex 12 binary'     => undef,
    'Cyngus X-1 binary' => undef,
    'to binary'         => undef,
);

done_testing;
