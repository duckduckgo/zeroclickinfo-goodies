#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_afelicioni";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::afelicioni
    )],
    'duckduckhack afelicioni' => test_zci('afelicioni is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack afelicioni is awesome' => undef,
);

done_testing;
