#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_jeet09";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::jeet09
    )],
    'duckduckhack jeet09' => test_zci('Jitu is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack jeet09 is awesome' => undef,
);

done_testing;
