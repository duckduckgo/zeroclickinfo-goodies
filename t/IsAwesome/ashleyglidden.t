#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_ashleyglidden";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::ashleyglidden
    )],
    'duckduckhack ashleyglidden' => test_zci('ashleyglidden is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack ashleyglidden is awesome' => undef,
);

done_testing;
