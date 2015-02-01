#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_enricofoltran";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::enricofoltran
    )],
    'duckduckhack enricofoltran' => test_zci('enricofoltran is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack enricofoltran is awesome' => undef,
);

done_testing;
