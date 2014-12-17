#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "what_does_the_fox_say";
zci is_cached   => 0;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::gamehelp16
    )],
    'duckduckhack gamehelp16' => test_zci('gamehelp16 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack gamehelp16 is awesome' => undef,
);

done_testing;
