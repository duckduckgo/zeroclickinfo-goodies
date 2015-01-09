#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_roshanr95";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::roshanr95 )],
    'duckduckhack roshanr95' => test_zci('roshanr95 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack roshanr95 is awesome' => undef,
);

done_testing;
