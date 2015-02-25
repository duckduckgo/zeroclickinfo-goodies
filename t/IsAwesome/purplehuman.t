#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_purplehuman";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::purplehuman
    )],
    'duckduckhack purplehuman' => test_zci('purplehuman is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack purplehuman is awesome' => undef,
);

done_testing;
