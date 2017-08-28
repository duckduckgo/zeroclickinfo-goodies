#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "jsminify";
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my @test_params = @_;

    return "",
        structured_answer => {

            id => "js_minify",

            data => {
                title => 'Minifier',
                subtitle => 'Enter code below, then click the button to minify or prettify'
            },

            templates => {
                group => "text",
                item => 0,
                options => {
                    content => "DDH.js_minify.content"
                }
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::JsMinify )],

    'minify js' => build_test(),
    'minify javascript' => build_test(),
    'minifier js' => build_test(),
    'minifier javascript' => build_test(),
    'js minifier' => build_test(),
    'javascript minifier' => build_test(),
    'js minify' => build_test(),
    'javascript minify' => build_test(),
    'json minify' => build_test(),
    'minify json' => build_test(),
    'json minifier' => build_test(),
    'minifier json' => build_test(),
    'minify css' => build_test(),

    'minify css in grunt' => undef,
    'js minify gulp' => undef,
);

done_testing;
