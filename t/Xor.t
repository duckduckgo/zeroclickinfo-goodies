#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'xor';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Xor
        )],
        '4 xor 5' => test_zci('1'),
        '5 ⊕ 79' => test_zci('74'),
        '9489 xor 394 xor 9349 xor 39 xor 29 xor 4967 xor 3985' => test_zci('7378')
);

done_testing;
