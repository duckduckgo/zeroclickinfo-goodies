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
        'this in binary' => test_zci('"this" as a string is "01110100011010000110100101110011" in binary.'),
        '12 in binary' => test_zci('"12" as decimal is "00001100" in binary.'),
        'that to binary' => test_zci('"that" as a string is "01110100011010000110000101110100" in binary.'),
        '127 to binary' => test_zci('"127" as decimal is "01111111" in binary.'),
        '256 to binary' => test_zci('"256" as decimal is "0000000100000000" in binary.'),
        '0x00 to binary' => test_zci('"0x00" as hex is "00000000" in binary.'),
        '0x1e to binary' => test_zci('"0x1e" as hex is "00011110" in binary.'),
        'xa1 to binary'  => test_zci('"xa1" as hex is "10100001" in binary.'),
        'ffff to binary' => test_zci('"ffff" as hex is "1111111111111111" in binary.'),
        'FEFE to binary' => test_zci('"FEFE" as hex is "1111111011111110" in binary.'),
        '0 to binary' => test_zci('"0" as decimal is "00000000" in binary.'),
        'foo in binary' => test_zci('"foo" as a string is "011001100110111101101111" in binary.'),
);

done_testing;
