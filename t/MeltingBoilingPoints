#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "melting_boiling_points";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::MeltingBoilingPoints )],
    # Tests for atomic mass
    'boiling point of Nitrogen' => test_zci(
            'Nitrogen (N), Boiling point 77.36 kelvin',
            structured_answer => {
                input => ['Nitrogen (N)'],
                operation => 'Boiling Point',
                result => '77.36 kelvin'
            },
        ),
    'boiling point of N' => test_zci(
            'Nitrogen (N), Boiling point 77.36 kelvin',
            structured_answer => {
                input => ['Nitrogen (N)'],
                operation => 'Boiling Point',
                result => '77.36 kelvin'
            },
        ),
    'boiling point of N' => test_zci(
            'Nitrogen (N), Boiling point 77.36 kelvin',
            structured_answer => {
                input => ['Nitrogen (N)'],
                operation => 'Boiling Point',
                result => '77.36 kelvin'
            },
        ),

    # Tests for atomic number
    'melting point of Nitrogen' => test_zci(
            'Nitrogen (N), Melting point 63.15',
            structured_answer => {
                input => ['Nitrogen (N)'],
                operation => 'Melting point',
                result => '63.15'
            },
        ),
    'melting point of N' => test_zci(
            'Nitrogen (N), Melting point 63.15',
            structured_answer => {
                input => ['Nitrogen (N)'],
                operation => 'Melting point',
                result => '63.15'
            },
        ),
         
    
    'melting point of hotdog' => undef,
    'boiling point of Canada' => undef,
);

done_testing;
