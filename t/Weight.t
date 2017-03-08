#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "weight";
zci is_cached   => 1;

sub build_structured_answer {
    my ($mass, $mass_kg, $weight) = @_;
    my $converted_mass = "";
    
    if($mass !~ /.*kg/) {
        $converted_mass = "($mass_kg kg) ";
    }
    
    return "Weight of a $mass mass on Earth is ${weight}N",
        structured_answer => {
            data => {
                title    => "Weight of a $mass ${converted_mass}mass on Earth is ${weight}N",
                subtitle => "Taking value of acceleration due to gravity on Earth as 9.80665m/s^2"
            },
            templates => {
                group => "text"
            }
        };
}

sub build_test{ test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Weight )],
    # - primary_example_queries
    'weight 5.12g'                               => build_test("5.12g", 0.00512, 0.050210048),
    'weight 5.12oz'                              => build_test("5.12oz", 0.144896, 1.4209443584),
    'Weight of 5.1 kg on earth'                  => build_test("5.1kg", 5.1, 50.013915),
    'What is the weight of a 5kg mass on Earth?' => build_test("5kg", 5, 49.03325),

    # Bad example queries
    'weight'     => undef,
    'weight abc' => undef,
    'weight 5'   => undef,
);

done_testing;
