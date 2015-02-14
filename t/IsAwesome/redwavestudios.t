#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_redwavestudios";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::redwavestudios
    )],
    'duckduckhack redwavestudios' => test_zci('redwavestudios is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack redwavestudios is awesome' => undef,
);

done_testing;

