#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_jgkamat";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::jgkamat )],

    'duckduckhack jgkamat' => test_zci('jgkamat is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack jgkamat is awesome' => undef,
);

done_testing;
