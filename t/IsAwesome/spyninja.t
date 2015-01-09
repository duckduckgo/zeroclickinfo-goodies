#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_spyninja";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(DDG::Goodie::IsAwesome::spyninja)],
    'duckduckhack spyninja' => test_zci('spyninja is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack spyninja is awesome' => undef,
);

done_testing;
