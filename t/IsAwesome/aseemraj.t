#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_aseemraj";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::aseemraj
    )],
    'duckduckhack aseemraj' => test_zci('aseemraj is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack aseemraj is awesome' => undef,
);

done_testing;
