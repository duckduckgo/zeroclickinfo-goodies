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
            operation => 'hex to decimal',
            result    => 15061036807694329193
        }
    ),
    '0x44696f21' => test_zci(
        '44696f21 base 16 = 1147760417 base 10',
        structured_answer => {
            input     => ['0x44696f21'],
            operation => 'hex to decimal',
            result    => 1147760417,
        }
    ),
    '0xffffffffffffffffffffff' => test_zci(
        'ffffffffffffffffffffff base 16 = 309485009821345068724781055 base 10',
        structured_answer => {
            input     => ['0xffffffffffffffffffffff'],
            operation => 'hex to decimal',
            result    => "309485009821345068724781055",
        }
    ),
    '0x44696f2Z'       => undef,
    'ascii 0x74657374' => undef,
);

done_testing;

