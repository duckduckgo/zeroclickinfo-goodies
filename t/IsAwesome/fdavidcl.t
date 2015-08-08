#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_fdavidcl";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::fdavidcl 
    )],
    'duckduckhack fdavidcl' => test_zci('fdavidcl is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack fdavidcl is awesome' => undef,
);

done_testing;
