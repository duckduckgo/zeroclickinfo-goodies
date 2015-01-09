#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_jimbrighter";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::jimbrighter )],
    'duckduckhack jimbrighter' => test_zci('jim-brighter is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack jimbrighter is awesome' => undef,
);

done_testing;
