#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'molar_mass';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my ($input, $mass) = @_;

    return "The molar mass of $input is $mass.",
        structured_answer => {

            data => {
                title    => $mass,
                subtitle => "The molar mass of $input"
            },

            templates => {
                group => 'text'
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::MolarMass )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    'molar mass of H2O' => build_test('H2O', '18.0153'),
    # - secondary_example_queries
    'molar mass of Al2(SO4)3' => build_test('Al2(SO4)3', '342.156'),
    'molar mass of Uuo2' => build_test('Uuo2', '588'),
    'molar mass of NaCl' => build_test('NaCl', '58.4426'),
    'molar mass of C2H3NaO2' => build_test('C2H3NaO2', '82.0347'),
    # Arbitrary Brackets
    'molar mass of ()()Na(())Cl' => build_test('()()Na(())Cl', '58.4426'),
    
    
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'molar mass of asdf' => undef,
    # Mismatched brackets:
    'molar mass of Al2(SO4))3' => undef,
    
    # Nonexistent Elements:
    'molar mass of HaO2' => undef,
    'molar mass of Uasd' => undef,
    
    # Incorrect integer placement:
    'molar mass of H3(4F)3' => undef,
    'molar mass of 4H3' => undef,
    
    # Special Characters:
    'molar mass of *(&)H2' => undef,
);

done_testing;
