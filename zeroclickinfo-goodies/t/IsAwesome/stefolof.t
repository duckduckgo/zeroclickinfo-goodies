#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_stefolof";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( 
        DDG::Goodie::IsAwesome::stefolof
    )],
    
    'duckduckhack stefolof' => test_zci('stefolof is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack stefolof is awesome' => undef,
);

done_testing;
