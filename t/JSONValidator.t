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
                title => 'JSON Beautifier & Validator',
                subtitle => 'Enter JSON below, then click the button to get beautified version of JSON and check for any syntax errors'
            },

            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.jsonvalidator.content'
                }
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::JSONValidator )],

    'json validate' => build_test(),
    'json validator' => build_test(),
    'json validation' => build_test(),
    'validate json' => build_test(),
    'validator json' => build_test(),
    'validation json' => build_test(),
    'json verify' => build_test(),
    'verify json' => build_test(),
    'json formatter' => build_test(),
    'formatter json' => build_test(),
    'json prettyprint' => build_test(),
    'prettyprint json' => build_test(),
    'json pretty print' => build_test(),
    'pretty print json' => build_test(),
    'json prettify' => build_test(),
    'prettify json' => build_test(),
    'json lint' => build_test(),
    'json lint checker' => build_test(),
    'json visualizer' => build_test(),

    'json viewer' => undef,
    'lint remover' => undef,
);

done_testing;
