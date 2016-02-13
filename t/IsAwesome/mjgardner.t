#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_mjgardner";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::mjgardner
    )],
    'duckduckhack mjgardner' => test_zci('mjgardner is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack mjgardner is awesome' => undef,
);

done_testing;
