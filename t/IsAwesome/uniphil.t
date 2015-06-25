#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_uniphil";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::uniphil
    )],
    'duckduckhack uniphil' => test_zci('uniphil is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack uniphil is awesome' => undef,
);

done_testing;
