#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'hex_to_dec';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::HexToDec )],
    '0xd1038d2e07b42569' => test_zci(
        'd1038d2e07b42569 base 16 = 15061036807694329193 base 10',
        structured_answer => {
            input     => ['0xd1038d2e07b42569'],
            operation => 'Hex to decimal',
            result    => 15061036807694329193
        }
    ),
    '0x44696f21' => test_zci(
        '44696f21 base 16 = 1147760417 base 10',
        structured_answer => {
            input     => ['0x44696f21'],
            operation => 'Hex to decimal',
            result    => 1147760417,
        }
    ),
    '0xffffffffffffffffffffff' => test_zci(
        'ffffffffffffffffffffff base 16 = 309485009821345068724781055 base 10',
        structured_answer => {
            input     => ['0xffffffffffffffffffffff'],
            operation => 'Hex to decimal',
            result    => "309485009821345068724781055",
        }
    ),
    '0xff in decimal' => test_zci(
        'ff base 16 = 255 base 10',
        structured_answer => {
            input     => ['0xff'],
            operation => 'Hex to decimal',
            result    => "255",
        }
    ),
    '0xff hex to dec' => test_zci(
        'ff base 16 = 255 base 10',
        structured_answer => {
            input     => ['0xff'],
            operation => 'Hex to decimal',
            result    => "255",
        }
    ),
    '0xff as base 10' => test_zci(
        'ff base 16 = 255 base 10',
        structured_answer => {
            input     => ['0xff'],
            operation => 'Hex to decimal',
            result    => "255",
        }
    ),
    '0xff in base-10' => test_zci(
        'ff base 16 = 255 base 10',
        structured_answer => {
            input     => ['0xff'],
            operation => 'Hex to decimal',
            result    => "255",
        }
    ),
    '0xff hex to base10' => test_zci(
        'ff base 16 = 255 base 10',
        structured_answer => {
            input     => ['0xff'],
            operation => 'Hex to decimal',
            result    => "255",
        }
    ),
    '0x44696f2Z'       => undef,
    'ascii 0x74657374' => undef,
    '0x255 hex'        => undef,
    '0x255 hex dec'    => undef,
    '0x255 to'         => undef,
    '255 as base 10'   => undef,
    'as decimal'       => undef,
    'hex to decimal'   => undef,
    'base10'           => undef,
    '0x01 + 0x02'      => undef,
    '20x40 in dec'     => undef,
    '0x'               => undef,
    'hex'              => undef,
    'to'               => undef,
);

done_testing;

