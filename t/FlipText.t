#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'flip_text';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::FlipText
        )],
        'flip text test' => test_zci("\x{0287}\x{0073}\x{01DD}\x{0287}"),
        'mirror text test' => test_zci("\x{0287}\x{0073}\x{01DD}\x{0287}"),
        'flip text my sentence' => test_zci('ǝɔuǝʇuǝs ʎɯ'),
        'mirror text text' => test_zci('ʇxǝʇ'),
);

done_testing;
