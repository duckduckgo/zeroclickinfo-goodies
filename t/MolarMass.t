#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => "molar_mass";
zci is_cached   => 1;

sub build_structured_answer{
    my($mass, $compound, $subscript) = @_;
    return "The molar mass of $compound is $mass g/mol.",
    structured_answer => {
        data => {
            title    => "$mass g/mol",
            subtitle => "The molar mass of $subscript is $mass g/mol."
        },
        templates => {
            group => "text"
        }
    }
}

sub build_test{ test_zci(build_structured_answer(@_))}

ddg_goodie_test(
    [qw( DDG::Goodie::MolarMass )],
    
    'molar mass of h2o' => build_test(18.015, "H2O", "H₂O"),
    
    'what is the molar mass of h2o' => build_test(18.015, "H2O", "H₂O"),
    
    'molar mass of c6h12o6' => build_test(180.156, "C6H12O6", "C₆H₁₂O₆"),
    
    'molar mass of' => undef,
    
    'molar mass of 1' => undef,
    
    'molar mass of a' => undef,
);

done_testing;
