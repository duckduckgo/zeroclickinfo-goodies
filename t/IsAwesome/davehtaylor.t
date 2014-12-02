#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_davehtaylor";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::davehtaylor
    )],
    'duckduckhack davehtaylor' => test_zci('davehtaylor is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack davehtaylor is awesome' => undef,
);

done_testing;
