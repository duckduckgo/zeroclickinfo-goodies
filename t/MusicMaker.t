#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "music_maker";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::MusicMaker )],
    'music maker' => test_zci('-ANY-'),
);

done_testing;
