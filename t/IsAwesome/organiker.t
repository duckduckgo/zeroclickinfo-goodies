#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_organiker";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::organiker
    )],
    'duckduckhack organiker' => test_zci('organiker is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack organiker is awesome' => undef,
);

done_testing;
