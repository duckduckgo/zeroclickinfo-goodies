#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_dean_t765";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::DeanT765
    )],
    'duckduckhack DeanT765' => test_zci('DeanT765 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack DeanT765 is awesome' => undef,
);

done_testing;
