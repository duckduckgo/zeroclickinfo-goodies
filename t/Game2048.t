#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 2048;
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Game2048 )],

    'play 2048' => test_zci(
        '',
        structured_answer => {
            data => ignore(),
            templates => {
                group => "text",
                item => 0,
                options => {
                    content => "DDH.game2048.content"
                },
            }
        }
    ),
    '2048 online' => undef
);

done_testing;
