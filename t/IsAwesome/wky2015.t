#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_wky2015";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::wky2015
    )],
    'duckduckhack wky2015' => test_zci('wky2015 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack wky2015 is awesome' => undef,
);

done_testing;
