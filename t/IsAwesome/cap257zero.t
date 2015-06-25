#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_cap257zero";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::cap257zero
    )],
    'duckduckhack cap257zero' => test_zci('cap257zero is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack cap257zero is awesome' => undef,
);

done_testing;
