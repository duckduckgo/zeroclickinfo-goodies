#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "quoidautre";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::Quoidautre
    )],
    'duckduckhack Quoidautre' => test_zci('Quoidautre is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack Quoidautre is awesome' => undef,
);

done_testing;