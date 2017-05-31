#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "ascii_to_hex";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::ASCIIToHEX )],
    'ascii to hex 12345678' => test_zci(
        '12345678 converts to 31 32 33 34 35 36 37 38',
        structured_answer => {
            input       => ['12345678'],
            operation   => 'ASCII to HEX',
            result      => '31 32 33 34 35 36 37 38'
        }
    ),
    '100156 convert ascii hex' => test_zci(
        '100156 converts to 31 30 30 31 35 36',
        structured_answer => {
            input       => ['100156'],
            operation   => 'ASCII to HEX',
            result      => '31 30 30 31 35 36'
        }
    ),
    'ascii hex conversion test string' => test_zci(
        'test string converts to 74 65 73 74 20 73 74 72 69 6e 67',
        structured_answer => {
            input       => ['test string'],
            operation   => 'ASCII to HEX',
            result      => '74 65 73 74 20 73 74 72 69 6e 67'
        }
    ),
    'convert ascii to hex Hello World!' => test_zci(
        'Hello World! converts to 48 65 6c 6c 6f 20 57 6f 72 6c 64 21',
        structured_answer => {
            input       => ['Hello World!'],
            operation   => 'ASCII to HEX',
            result      => '48 65 6c 6c 6f 20 57 6f 72 6c 64 21'
        }
    ),
    'Final Test... GO ascii hex' => test_zci(
        'Final Test... GO converts to 46 69 6e 61 6c 20 54 65 73 74 2e 2e 2e 20 47 4f',
        structured_answer => {
            input       => ['Final Test... GO'],
            operation   => 'ASCII to HEX',
            result      => '46 69 6e 61 6c 20 54 65 73 74 2e 2e 2e 20 47 4f'
        }
    )
);

done_testing;
