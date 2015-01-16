#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_blito";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::Blito )],
    'duckduckhack Blito' => test_zci('Blito is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack Blito is awesome' => undef,
);

done_testing;
