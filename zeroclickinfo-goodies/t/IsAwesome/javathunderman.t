#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome:javathunderman";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::javathunderman
    )],
    'duckduckhack javathunderman' => test_zci('javathunderman is awesome and has created a goodie!'),
    'duckduckhack javathunderman is awesome' => undef,
);

done_testing;
