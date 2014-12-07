#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_rp4";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::rp4 )],
    'duckduckhack rp4' => test_zci('rp4 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack rp4 is awesome' => undef,
);

done_testing;
