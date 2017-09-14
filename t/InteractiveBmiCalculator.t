#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'interactive_bmi_calculator';
zci is_cached   => 1;

my $text = 'Body Mass Index Calculator';

sub build_test {
    return test_zci($text,
        structured_answer => {
            id => 'interactive_bmi_calculator',
            name => 'BMI Calculator',
            data => {
                title => $text,
            },
            templates => {
                group => 'text',
                options => {
                    content => 'DDH.interactive_bmi_calculator.content'
                }
            }
        }
    )
}

ddg_goodie_test(
    ['DDG::Goodie::InteractiveBmiCalculator'],
    'body mass index calculator'      => build_test(),
    'bmi calculator'                  => build_test(),
    'calculate bmi'                   => build_test(),
    'bmi formula'                     => build_test(),
    'how to calculate bmi'            => build_test(),
    
    #Invalid queries
    'what is body mass index'    => undef,
    'body mass index categories' => undef
);

done_testing;
