#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_v0tti";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::v0tti
    )],
    'duckduckhack v0tti' => test_zci('v0tti is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack v0tti is awesome' => undef,
);

done_testing;
