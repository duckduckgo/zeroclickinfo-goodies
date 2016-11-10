#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'sass_to_css';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my @test_params = @_;

    return "",
        structured_answer => {
            data => {
                title => 'Sass to Css Converter',
                subtitle => 'Enter SASS below, then click the button to convert it to CSS',
            },

            templates => {
                group => "text",
                item => 0,
                options  => {
                    content  => "DDH.sass_to_css.content"
                }
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::SassToCss )],

    'sass to css' => build_test(),
    'sass to css converter' => build_test(),
    'compile sass to css' => build_test(),
    'converter sass to css' => build_test(),
    'sass to css compiler' => build_test(),
    'sass convert to css' => build_test(),
    'compile sass to css' => build_test(),

    'convert sass' => undef,

);

done_testing;
