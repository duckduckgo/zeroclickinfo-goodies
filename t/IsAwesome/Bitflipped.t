#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_bitflipped";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::Bitflipped
    )],
    'duckduckhack bitflipped' => test_zci('bitflipped is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack bitflipped is awesome' => undef,
);

done_testing;
