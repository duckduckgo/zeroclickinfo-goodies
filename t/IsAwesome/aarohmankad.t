#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_aarohmankad";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::aarohmankad
    )],
    'duckduckhack aarohmankad' => test_zci('aarohmankad is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack aarohmankad is awesome' => undef,
);

done_testing;
