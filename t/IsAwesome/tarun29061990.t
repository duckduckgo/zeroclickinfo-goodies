#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_tarun29061990";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::tarun29061990
    )],
    'duckduckhack tarun29061990' => test_zci('tarun29061990 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack tarun29061990 is awesome' => undef,
);

done_testing;
