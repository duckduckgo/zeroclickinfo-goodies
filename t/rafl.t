#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci is_cached => 0;
zci answer_type => 'rafl';

ddg_goodie_test(
        [qw(
                DDG::Goodie::Rafl
        )],
        'rafl' => test_zci(
            qr/rafl.*everywhere/i,
        ),
        '!rafl' => test_zci(
            qr/rafl.*everywhere/i,
        ),
        'rafl everywhere' => test_zci(
            qr/rafl.*everywhere/i,
        ),
);

done_testing;
