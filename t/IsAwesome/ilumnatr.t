#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_ilumnatr";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( 
        DDG::Goodie::IsAwesome::ilumnatr 
    )],
    'duckduckhack ilumnatr' => test_zci('ilumnatr is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack ilumnatr is awesome' => undef,
);

done_testing;
