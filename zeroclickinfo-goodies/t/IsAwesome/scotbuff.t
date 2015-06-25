#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_scotbuff";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::scotbuff
    )],
    'duckduckhack scotbuff' => test_zci('scotbuff is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack scotbuff is awesome' => undef,
);

done_testing;
