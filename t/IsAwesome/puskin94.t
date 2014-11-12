#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_puskin94";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::puskin94
    )],
    'duckduckhack puskin94' => test_zci('puskin94 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack puskin94 is awesome' => undef,
);

done_testing;
