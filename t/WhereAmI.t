#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'whereami';
zci is_cached   => 0;

my @test_loc = (
    'Lat: 40.1246, Lon: -75.5385 (near Phoenixville, PA)',
    structured_answer => {
        input     => [],
        operation => 'Apparent current location',
        result    => 'Lat: 40.1246, Lon: -75.5385 (near Phoenixville, PA)'
    });

ddg_goodie_test(
    [qw(DDG::Goodie::WhereAmI)],
    'where am I?'             => test_zci(@test_loc),
    'my location'             => test_zci(@test_loc),
    'my location is nowhere!' => undef,
);

done_testing;
