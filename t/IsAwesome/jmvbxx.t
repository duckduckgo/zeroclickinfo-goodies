#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_jmvbxx";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( 
        DDG::Goodie::IsAwesome::jmvbxx 
    )],
    
    'duckduckhack jmvbxx' => test_zci('jmvbxx is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack jmvbxx is awesome' => undef,
    
);

done_testing;
