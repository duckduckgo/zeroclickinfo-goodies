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

    '2048' => test_zci(
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
    'what is 2048?' => undef,
    'how to play 2048' => undef,
    '204823 34232' => undef,
    '123:play 2048:12398' => undef,
    '2400:cb00:2048:1::6817:f2fe' => undef,
    '2048:6093:99ca:bc7:0:0:0:0' => undef
    
);

done_testing;
