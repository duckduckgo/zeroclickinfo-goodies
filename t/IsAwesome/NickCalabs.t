#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_nick_calabs";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::NickCalabs
    )],
        'duckduckhack NickCalabs' => test_zci('NickCalabs is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
        'duckduckhack NickCalabs is awesome' => undef,
);

done_testing;
