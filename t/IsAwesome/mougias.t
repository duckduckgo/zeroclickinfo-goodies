#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_mougias";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::mougias
    )],
    'duckduckhack mougias' => test_zci('mougias is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack mougias is awesome' => undef,
);

done_testing;
