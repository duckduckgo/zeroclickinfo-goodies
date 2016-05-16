#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "screen_resolution";
zci is_cached   => 1;

my @answer = test_zci(
    undef,
    structured_answer => {
        data => {
            title => "Your screen resolution is [Loading...]"
        },
        templates => {
            group => 'icon',
            item => 0,
            options => {
                moreAt => 0
            }
        }
    }
);

ddg_goodie_test(
    [qw( DDG::Goodie::ScreenResolution )],
    'screen resolution' => @answer,
    'what is my display resolution' => @answer,
    'whats my screen resolution' => @answer,
    'what is my screen resolution' => @answer,
    'what is the resolution of my screen?' => @answer,
    'my screen resolution' => @answer,
    'blah blah screen resolution' => undef,
);

done_testing;
