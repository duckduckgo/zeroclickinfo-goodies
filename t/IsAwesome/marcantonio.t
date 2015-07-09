#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_marcantonio";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
       DDG::Goodie::IsAwesome::marcantonio
    )],
    'duckduckhack marcantonio' => test_zci('marcantonio is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack marcantonio is awesome' => undef,
);

done_testing;
