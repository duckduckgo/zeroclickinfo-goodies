#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_xinhhuynh";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::xinhhuynh )],
    'duckduckhack xinhhuynh' => test_zci('xinhhuynh is awesome and has successfully completed the tutorial!'),
    'duckduckhack xinhhuynh is awesome' => undef,
);

done_testing;
