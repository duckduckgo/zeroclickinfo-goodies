#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_ufanete";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::ufanete )],
    'duckduckhack ufanete' => test_zci('ufanete is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack ufanete is awesome' => undef,
);


done_testing;
