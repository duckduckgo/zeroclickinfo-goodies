#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_gohar94";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::gohar94
    )],
    'duckduckhack gohar94' => test_zci('gohar94 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack gohar94 is awesome' => undef,
);

done_testing;
