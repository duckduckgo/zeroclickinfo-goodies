#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_bigx_mac";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::BigxMac
    )],
    'duckduckhack BigxMac' => test_zci('BigxMac is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack BigxMac is awesome' => undef,
);

done_testing;
