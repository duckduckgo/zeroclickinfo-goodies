#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_gjskha";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::gjskha
    )],
    'duckduckhack gjskha' => test_zci('gjskha is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack gjskha is awesome' => undef,
);
done_testing;
