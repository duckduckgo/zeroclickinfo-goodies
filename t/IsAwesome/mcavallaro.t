#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_mcavallaro";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::mcavallaro )],
    'duckduckhack mcavallaro' => test_zci('mcavallaro is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack mcavallaro is awesome' => undef,
);

done_testing;
