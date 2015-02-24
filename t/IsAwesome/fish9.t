#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_fish9";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::fish9
    )],
    'duckduckhack fish9' => test_zci('fish9 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack fish9 is awesome' => undef,
);

done_testing;
