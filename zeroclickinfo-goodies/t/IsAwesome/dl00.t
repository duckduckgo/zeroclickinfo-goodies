#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_dl00";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::dl00 )],
    'duckduckhack dl00' => test_zci('dl00 is awesome and successfully completed the initiation tutorial for DuckDuckHack.'),
    'duckduckhack dl00 is awesome' => undef,
);

done_testing;
