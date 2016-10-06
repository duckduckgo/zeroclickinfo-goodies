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

        'minify css' => undef,
        'js minify gulp' => undef,
);

done_testing;
