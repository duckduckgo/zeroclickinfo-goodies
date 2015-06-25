#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_echosa";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( 
        DDG::Goodie::IsAwesome::Echosa
    )],
    'duckduckhack echosa' => test_zci('Echosa is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack echosa is awesome' => undef,
);

done_testing;
