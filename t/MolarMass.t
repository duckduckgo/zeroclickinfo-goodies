#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'molar_mass';
zci is_cached   => 1;

sub build_structured_answer {
    my ($input, $mass) = @_;

    return "The molar mass of $input is $mass g/mol.",
        structured_answer => {

            data => {
                title    => "$mass g/mol",
                subtitle => "$input"
            },

            templates => {
                group => 'text'
            }
        };
}

sub build_alternate_answer {
    my ($input, $mass, $name) = @_;

    return "The molar mass of $name ($input) is $mass g/mol.",
        structured_answer => {

            data => {
                title    => "$mass g/mol",
                subtitle => "$name, $input"
            },

            templates => {
                group => 'text'
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

sub build_test_alt { test_zci(build_alternate_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::MolarMass )],

    # - primary_example_queries
    'molar mass of H2O' => build_test_alt('H2O', '18.01528', 'Water'),

    # - secondary_example_queries
    'molar mass of Al2(SO4)3' => build_test_alt('Al2(SO4)3', '342.150876', 'Aluminium Sulfate'),
    'molar mass of NaCl' => build_test_alt('NaCl', '58.44277', 'Sodium Chloride'),
    
    'molar mass of Uuo2' => build_test('Uuo2', '588'),
    'molar mass of C2H3NaO2' => build_test('C2H3NaO2', '82.0347'),
    'molar mass of Al123(S4(Uuo2Lv4)3Ca4)8' => build_test('Al123(S4(Uuo2Lv4)3Ca4)8', '47867.3854'),

    # Arbitrary Brackets test
    'molar mass of ()()Na(())Cl' => build_test('()()Na(())Cl', '58.4426'),
    
    # Other Triggers
    'atomic mass of NaCl' => build_test_alt('NaCl', '58.44277', 'Sodium Chloride'),
    
    ## Failing tests:
    'molar mass of asdf' => undef,

    # Mismatched brackets:
    'molar mass of Al2(SO4))3' => undef,
    
    # Nonexistent Elements:
    'molar mass of HaO2' => undef,
    'molar mass of Uasd' => undef,
    
    # Incorrect integer placement:
    'molar mass of H3(4F)3' => undef,
    'molar mass of 4H3' => undef,
    
    # Unwanted Characters:
    'molar mass of *(&)H2' => undef,
);

done_testing;
