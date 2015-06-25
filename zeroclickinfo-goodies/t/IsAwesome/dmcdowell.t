#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_dmcdowell";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::dmcdowell )],
    'duckduckhack dmcdowell' => test_zci('dmcdowell is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack dmcdowell is awesome' => undef,
);

done_testing;
