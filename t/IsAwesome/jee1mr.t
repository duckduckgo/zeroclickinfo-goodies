#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_jee1mr";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::jee1mr
    )],
    'duckduckhack jee1mr' => test_zci('jee1mr is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack jee1mr is awesome' => undef,
);

done_testing;
