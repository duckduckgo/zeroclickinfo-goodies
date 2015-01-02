#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_zhou";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::zhou
    )],
    'duckduckhack zhou' => test_zci('zhou is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack zhou is awesome' => undef,
);

done_testing;
