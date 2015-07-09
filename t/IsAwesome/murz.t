#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_murz";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::murz
    )],
    'duckduckhack murz' => test_zci('murz is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack murz is awesome' => undef,
);

done_testing;
