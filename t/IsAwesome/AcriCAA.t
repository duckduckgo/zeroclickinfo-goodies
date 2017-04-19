#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_acri_caa";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::AcriCAA
    )],
    'duckduckhack AcriCAA' => test_zci('AcriCAA is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack AcriCAA is awesome' => undef,
);

done_testing;
