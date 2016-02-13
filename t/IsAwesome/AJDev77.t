#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_ajdev77";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::AJDev77
    )],
    'duckduckhack AJDev77' => test_zci('AJDev77 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack AJDev77 is awesome' => undef,
);

done_testing;
