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

    # primary example queries
    'molar mass of H2O' => build_test_alt('H2O', '18.01528', 'Water'),

    # secondary example queries
    'molar mass of Al2(SO4)3' => build_test_alt('Al2(SO4)3', '342.150876', 'Aluminium Sulfate'),
    'molar mass of NaCl' => build_test_alt('NaCl', '58.44277', 'Sodium Chloride'),
    'molar mass of HCl' => build_test_alt('HCl', '36.46094', 'Hydrochloric Acid'),
    'molar mass of Sulfuric Acid' => build_test_alt('H2SO4', '98.07848', 'Sulfuric Acid'),
    
    # lowercase example queries
    'molar mass of al2(so4)3' => build_test_alt('Al2(SO4)3', '342.150876', 'Aluminium Sulfate'),
    'molar mass of nacl' => build_test_alt('NaCl', '58.44277', 'Sodium Chloride'),
    'molar mass of sulfuric acid' => build_test_alt('H2SO4', '98.07848', 'Sulfuric Acid'),
    'molar mass of h2so4' => build_test_alt('H2SO4', '98.07848', 'Sulfuric Acid'),
    'molar mass of hcl' => build_test_alt('HCl', '36.46094', 'Hydrochloric Acid'),
    
    # edge case tests
    'molar mass of Uuo2' => build_test('Uuo2', '588'),
    'molar mass of C2H3NaO2' => build_test('C2H3NaO2', '82.0347'),
    'molar mass of Al123(S4(Uuo2Lv4)3Ca4)8' => build_test('Al123(S4(Uuo2Lv4)3Ca4)8', '47867.3854'),

    # Arbitrary Brackets test
    'molar mass of ()()Na(())Cl' => build_test('()()Na(())Cl', '58.4426'),
    
    # Other Triggers
    'what is the molar mass of Al2(SO4)3' => build_test_alt('Al2(SO4)3', '342.150876', 'Aluminium Sulfate'),
    'whats the molar mass of NaCl' => build_test_alt('NaCl', '58.44277', 'Sodium Chloride'),
    'hydrochloric acid molar mass' => build_test_alt('HCl', '36.46094', 'Hydrochloric Acid'),
    'whats the molar mass of hydrochloric acid?' => build_test_alt('HCl', '36.46094', 'Hydrochloric Acid'),
    'what\'s the molar mass of hydrochloric acid?' => build_test_alt('HCl', '36.46094', 'Hydrochloric Acid'),
    'molar mass nacl' => build_test_alt('NaCl', '58.44277', 'Sodium Chloride'),
    
    
    
    # ----- Failing tests: ------
    # Primary failing example queries:
    'molar mass of asdf' => undef,
    'molar mass of' => undef,

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
    'molar mass of Al2H^2' => undef,
    
    # Random placement of the words molar mass
    'something something molar mass haha' => undef,
    'mmolar masses' => undef,
    'hmolar mass' => undef,
    'molar mass' => undef,
);

done_testing;
