#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'ascii_conversion';
zci is_cached => 1;

ddg_goodie_test([qw(
          DDG::Goodie::Ascii
          )
    ],
    '01101010 to ascii' => test_zci(
        '01101010 in binary is "j" in ASCII',
        structured_answer => {
            input     => ['01101010'],
            operation => 'binary to ASCII',
            result    => 'j',
        }
    ),
    '00111001 to ascii' => test_zci(
        '00111001 in binary is "9" in ASCII',
        structured_answer => {
            input     => ['00111001'],
            operation => 'binary to ASCII',
            result    => '9',
        }
    ),
    '01110100011010000110100101110011 in ascii' => test_zci(
        '01110100011010000110100101110011 in binary is "this" in ASCII',
        structured_answer => {
            input     => ['01110100011010000110100101110011'],
            operation => 'binary to ASCII',
            result    => 'this',
        }
    ),
    '01110100011010000110000101110100 to ascii' => test_zci(
        '01110100011010000110000101110100 in binary is "that" in ASCII',
        structured_answer => {
            input     => ['01110100011010000110000101110100'],
            operation => 'binary to ASCII',
            result    => 'that',
        }
    ),
    '0110100001100101011011000110110001101111 to ascii' => test_zci(
        '0110100001100101011011000110110001101111 in binary is "hello" in ASCII',
        structured_answer => {
            input     => ['0110100001100101011011000110110001101111'],
            operation => 'binary to ASCII',
            result    => 'hello',
        }
    ),
);

done_testing;

