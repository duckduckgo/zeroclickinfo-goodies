#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_black616angel";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::Black616Angel
    )],
    'duckduckhack Black616Angel' => test_zci('Black616Angel is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack Black616Angel is awesome' => undef,
);

done_testing;
