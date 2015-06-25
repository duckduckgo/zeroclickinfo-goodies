#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_lynbarry";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::Lynbarry
    )],
    'duckduckhack lynbarry' => test_zci('Lynbarry is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack lynbarry is awesome' => undef,
);

done_testing;
