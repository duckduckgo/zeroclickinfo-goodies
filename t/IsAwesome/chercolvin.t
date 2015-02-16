#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_chercolvin";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::chercolvin )],
    'duckduckhack chercolvin' => test_zci('chercolvin is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack chercolvin is awesome' => undef,
);

done_testing;
