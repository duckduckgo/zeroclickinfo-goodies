#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'interactive_bmi_calculator';
zci is_cached   => 1;

my $text = 'Body Mass Index Calculator';

ddg_goodie_test(
    ['DDG::Goodie::InteractiveBmiCalculator'],
    'body mass index' => test_zci(
        $text,
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
);

done_testing;
