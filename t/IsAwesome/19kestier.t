#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_19kestier";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::19kestier
    )],
    'duckduckhack 19kestier' => test_zci('19kestier is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack 19kestier is awesome' => undef,
);

done_testing;
