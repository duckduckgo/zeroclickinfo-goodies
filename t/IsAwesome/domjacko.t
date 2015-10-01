#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_domjacko";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::domjacko
    )],
    'duckduckhack domjacko' => test_zci('domjacko is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack domjacko is awesome' => undef,
);

done_testing;
