#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_ag8";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::ag8
    )],
    'duckduckhack ag8' => test_zci('ag8 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack ag8 is awesome' => undef,
);

done_testing;
