#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'htmlbeautifier';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my @test_params = @_;

        return "",
            structured_answer => {

                id => "html_beautifier",

                data => {
                    title => 'HTML Beautifier',
                    subtitle => 'Reformat HTML code by adding proper indentation.'
                },

                templates => {
                    group => "text",
                    item => 0,
                    options => {
                        content => "DDH.html_beautifier.content"
                    }
                }
            };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::HtmlBeautifier )],

        'beautify html' => build_test(),
        'html beautifier online' => build_test(),
        'prettify html tool' => build_test(),
        'online html cleanup' => build_test(),
        'html code cleanup' => build_test(),
        'html cleanup code' => build_test(),
        'html cleanup utility' => build_test(),
        'html prettify online' => build_test(),
        'html prettify tool' => build_test(),
        'reformat html5 tool' => build_test(),
        'prettify html5 code' => build_test(),
        'prettify html5' => build_test(),

        'php beautify' => undef,
        'html5 beatify library' => undef,
        'js beautify online' => undef,
        'code beautify online' => undef,
        'html prettified' => undef,
        'css beautifier tool' => undef,
        'online pretty print' => undef,
        'beautify code' => undef,
        'php html beautifier' => undef
);

done_testing;
