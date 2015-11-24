#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_rathoreanirudh";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::rathoreanirudh
    )],
    'duckduckhack rathoreanirudh' => test_zci('rathoreanirudh is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack rathoreanirudh is awesome' => undef,
);

done_testing;
