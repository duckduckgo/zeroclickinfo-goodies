#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'loan_calculator';
zci is_cached   => 1;

sub build_structured_answer {
    my @test_params = @_;

    return 'plain text response',
        structured_answer => {

            data => {
                title    => 'Loan Calculator',
            },

            templates => {
                group => 'text',
                options => {
                    content => "DDH.loan_calculator.content" 
                }
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::LoanCalculator )],
   
    # queries that should trigger
    'loan calculator' => build_test(),
    'mortgage calculator' => build_test(),

    # queries that shouldn't trigger
    'how much to borrow a loan' => undef,
    'get a mortgage' => undef,
    'calculate ppi' => undef,
    'mortgage brokers' => undef,
    'get cheap finance' => undef,
);

done_testing;
