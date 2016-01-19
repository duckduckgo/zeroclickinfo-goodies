#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_gmahesh23";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::gmahesh23
    )],
    'duckduckhack gmahesh23' => test_zci('gmahesh23 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack gmahesh23 is awesome' => undef,
);

done_testing;
