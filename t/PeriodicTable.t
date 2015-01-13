#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "periodic_table";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::PeriodicTable )],
    # Tests for atomic mass
    'atomic mass of Nitrogen' => test_zci(
            'Nitrogen (N), Atomic mass 14.007 u',
            structured_answer => {
                input => ['Nitrogen (N)'],
                operation => 'Atomic Mass',
                result => '14.007 u'
            },
        ),
    'atomic mass of N' => test_zci(
            'Nitrogen (N), Atomic mass 14.007 u',
            structured_answer => {
                input => ['Nitrogen (N)'],
                operation => 'Atomic Mass',
                result => '14.007 u'
            },
        ),
    'N atomic mass' => test_zci(
            'Nitrogen (N), Atomic mass 14.007 u',
            structured_answer => {
                input => ['Nitrogen (N)'],
                operation => 'Atomic Mass',
                result => '14.007 u'
            },
        ),

    # Tests for atomic number
    'atomic number of Nitrogen' => test_zci(
            'Nitrogen (N), Atomic number 7',
            structured_answer => {
                input => ['Nitrogen (N)'],
                operation => 'Atomic Number',
                result => '7'
            },
        ),
    'atomic number of N' => test_zci(
            'Nitrogen (N), Atomic number 7',
            structured_answer => {
                input => ['Nitrogen (N)'],
                operation => 'Atomic Number',
                result => '7'
            },
        ),
    'N atomic number' => test_zci(
            'Nitrogen (N), Atomic number 7',
            structured_answer => {
                input => ['Nitrogen (N)'],
                operation => 'Atomic Number',
                result => '7'
            },
        ),
        
    # Tests for Mercury because it has two names (Mercury and Hydrargyrum)
    'atomic number of Mercury' => test_zci(
            'Mercury (Hg), Atomic number 80',
            structured_answer => {
                input => ['Mercury (Hg)'],
                operation => 'Atomic Number',
                result => '80'
            },
        ),
    'atomic number of Hydrargyrum' => test_zci(
            'Hydrargyrum (Hg), Atomic number 80',
            structured_answer => {
                input => ['Hydrargyrum (Hg)'],
                operation => 'Atomic Number',
                result => '80'
            },
        ),

    # Tests for Copernicium because it has two symbols (Cn and Uub)
    'atomic number of Cn' => test_zci(
            'Copernicium (Cn), Atomic number 112',
            structured_answer => {
                input => ['Copernicium (Cn)'],
                operation => 'Atomic Number',
                result => '112'
            },
        ),
    'atomic number of Uub' => test_zci(
            'Ununbium (Uub), Atomic number 112',
            structured_answer => {
                input => ['Ununbium (Uub)'],
                operation => 'Atomic Number',
                result => '112'
            },
        ),
 
    # Queries on which the answer should not trigger
    'atomic number' => undef,
    'atomic mass' => undef,
    'atomic number of hotdog' => undef,
    'atomic mass of Canada' => undef,
);

done_testing;
