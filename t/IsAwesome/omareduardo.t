#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_omareduardo";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::omareduardo )],
    'duckduckhack omareduardo' => test_zci('omareduardo is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack omareduardo is awesome' => undef,
);

done_testing;
