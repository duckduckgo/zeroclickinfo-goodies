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
        id => 'whereami',
        name => 'Map',
        model => 'Place',
        view => 'Map',
        data => {
            id => 'whereami_id',
            name => 'Apparent current location',
            city => 'Phoenixville',
            lat => 40.1246,
            lon => -75.5385
        },
        meta => {
            zoomValue => 3,
            sourceName => 'DDG GeoIP',
            sourceUrl => 'http://duckduckgo.com'
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
