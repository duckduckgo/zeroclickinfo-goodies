#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'where_am_i';
zci is_cached   => 0;

my @test_loc = (
    '',
    structured_answer => {
        id => 'where_am_i',
        name => 'Answer',
        data => {
            lat => 40.1246,
            lon => -75.5385,
            display=> "Phoenixville, PA, United States"
        },
        templates => {
            group => 'places'
        }
    });

ddg_goodie_test(
    [qw(DDG::Goodie::WhereAmI)],
    'where am I'              => test_zci(@test_loc),
    'where am I?'             => test_zci(@test_loc),
    'my location'             => test_zci(@test_loc),
    'my location is nowhere!' => undef,
);

done_testing;
