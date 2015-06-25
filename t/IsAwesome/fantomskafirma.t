#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_fantomskafirma";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::fantomskafirma
    )],
    'duckduckhack fantomskafirma' => test_zci('fantomskafirma is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack fantomskafirma is awesome' => undef,
);
done_testing()