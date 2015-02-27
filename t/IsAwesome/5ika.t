#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_5ika";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::5ika )],
    'duckduckhack 5ika' => test_zci('Sika is awesome !'),
    'duckduckhack 5ika is awesome !' => undef,
);

done_testing;
