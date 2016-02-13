#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_bfmags";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::bfmags
    )],
    'duckduckhack bfmags' => test_zci('bfmags is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack bfmags is awesome' => undef,
);

done_testing;
