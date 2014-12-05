#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_max_power9";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
    DDG::Goodie::IsAwesome::MaxPower9
    )],
    'duckduckhack MaxPower9' => test_zci('MaxPower9 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack MaxPower9 is awesome' => undef,
);

done_testing;
