#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_kfloey";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( 
        DDG::Goodie::IsAwesome::kfloey 
    )],
    'duckduckhack kfloey' => test_zci('kfloey is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack kfloey is awesome' => undef,
);

done_testing;
