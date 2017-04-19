#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_amolveer";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::amolveer
    )],
    'duckduckhack amolveer' => test_zci('amolveer is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack amolveer is awesome' => undef,
);

done_testing;
