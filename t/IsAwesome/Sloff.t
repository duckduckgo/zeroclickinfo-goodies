#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_sloff";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::Sloff )],
    'duckduckhack sloff' => test_zci('Ettienne Pitts is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack sloff is awesome' => undef,
);

done_testing;
