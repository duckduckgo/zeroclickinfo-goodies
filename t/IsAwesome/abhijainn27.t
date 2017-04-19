#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_abhijainn27";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::abhijainn27
    )],
    'duckduckhack abhijainn27' => test_zci('abhijainn27 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack abhijainn27 is awesome' => undef,
);

done_testing;
