#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'bmi';
zci is_cached   => 1;


sub build_structured_answer {
    my @test_params = @_;

    return "Your BMI is $test_params[0]",
        structured_answer => {
            id => 'bmi',
            name => 'Answer',

            data => {
                title    => "BMI",
                subtitle => "Your BMI is $test_params[0]",
            },

            templates => {
                group => 'text',
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::BMI )],
    
    'bmi 43kg 100cm' => build_test('43.0'),
    'body mass index 120 cm 50 kg' => build_test('34.7'),
    'bmi 43 100' => undef,
    'BMI 30 inches 50 pounds' => undef,
    'bmi' => undef,
);

done_testing;
