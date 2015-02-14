#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_muj";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::muj
    )],
    'duckduckhack muj' => test_zci('muj is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack muj is awesome' => undef,
);

done_testing;
