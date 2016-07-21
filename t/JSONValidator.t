#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'jsonvalidator';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my @test_params = @_;

    return '',
        structured_answer => {

            id => "json_validator",

            data => {
                title => 'JSON Validator',
                subtitle => 'Enter your JSON below and click on the button to check if it\'s valid'
            },

            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.json_validator.content'
                }
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::JSONValidator )],

    'json validator' => build_test(),
);

done_testing;
