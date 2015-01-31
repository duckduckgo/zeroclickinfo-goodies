#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_thejdeep";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::thejdeep
    )],
    'duckduckhack thejdeep' => test_zci('thejdeep is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack thejdeep is awesome' => undef,
);

done_testing;
