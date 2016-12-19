#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "molar_mass";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::MolarMass )],
    
    'molar mass of h2o' => test_zci(
        'The molar mass of H2O is 18.015 g/mol.',
        html => 'The molar mass of <strong>H<sub>2</sub>O</strong> is <strong>18.015 g/mol</strong>.'
    ),
    
    'what is the molar mass of h2o' => test_zci(
        'The molar mass of H2O is 18.015 g/mol.',
        html => 'The molar mass of <strong>H<sub>2</sub>O</strong> is <strong>18.015 g/mol</strong>.'
    ),
    
    'molar mass of c6h12o6' => test_zci(
        'The molar mass of C6H12O6 is 180.156 g/mol.',
        html => 'The molar mass of <strong>C<sub>6</sub>H<sub>12</sub>O<sub>6</sub></strong> is <strong>180.156 g/mol</strong>.'
    ),
    
    'molar mass of' => undef,
    
    'molar mass of 1' => undef,
    
    'molar mass of a' => undef,
);

done_testing;
