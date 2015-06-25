#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_isleofmax";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
       DDG::Goodie::IsAwesome::isleofmax 
    )],
    "duckduckhack isleofmax" => test_zci('isleofmax is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack isleofmax is awesome' => undef,
);

done_testing;
