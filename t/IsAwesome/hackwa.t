#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_hackwa";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( 
        DDG::Goodie::IsAwesome::hackwa 
    )],
    'duckduckhack hackwa' => test_zci('hackwa is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack hackwa is awesome' => undef,
);

done_testing;
