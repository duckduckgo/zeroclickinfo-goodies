#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_justinvee";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::justinvee 
    )],
    
    'duckduckhack justinvee' => test_zci('justinvee is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack justinvee is awesome' => undef,
);

done_testing;
