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

                    id => "js_beautifier",

                    data => {
                        title => 'JavaScript Beautifier',
                        subtitle => 'Enter code below, then click the button to beautify'
                    },

                    templates => {
                        group => 'text',
                        item => 0,
                        options => {
                            content => 'DDH.js_beautifier.content'
                        }
                    }
         };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::JsBeautifier)],

    'js beautify' => build_test(),

    'minify css' => undef,
    'js minify gulp' => undef,
);

done_testing;
