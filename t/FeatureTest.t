#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DDG::Test::Location;
use DDG::Test::Language;
use utf8;

zci answer_type => 'featuretest';
zci is_cached => 0;

ddg_goodie_test (
    [
        'DDG::Goodie::FeatureTest'
    ],

    DDG::Request->new( query_raw => 'test all the plugin features', 'language' => test_language('us'), 'location' => test_location('us')) => 
        test_zci('Country United States Language English of United States Umlaut äöü')
);
done_testing;
