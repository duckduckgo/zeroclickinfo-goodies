#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_vedantham";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::vedantham
    )],
    'duckduckhack vedantham' => test_zci('vedantham is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack vedantham is awesome' => undef,
);

done_testing;
