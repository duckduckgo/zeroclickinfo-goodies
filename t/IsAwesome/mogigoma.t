#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_mogigoma";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::mogigoma
    )],
    'duckduckhack mogigoma' => test_zci('Mogigoma is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack mogigoma is awesome' => undef,
);

done_testing;
