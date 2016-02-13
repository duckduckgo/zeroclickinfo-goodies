#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_claytonspinner";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( 
        DDG::Goodie::IsAwesome::claytonspinner
    )],
    'duckduckhack claytonspinner' => test_zci('claytonspinner is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack claytonspinner is awesome' => undef,
);

done_testing;
