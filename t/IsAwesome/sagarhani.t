#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_sagarhani";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::sagarhani
    )],
    'duckduckhack sagarhani' => test_zci('sagarhani is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack sagarhani is awesome' => undef,
);

done_testing;
