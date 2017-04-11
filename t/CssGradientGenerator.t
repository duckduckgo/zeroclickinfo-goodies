#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'css_gradient_generator';
zci is_cached   => 1;

sub build_structured_answer {
    return 'CSS Gradient Generator',
        structured_answer => {

            data => {

            },

            templates => {
                group => 'text',
                options => {
                    content => "DDH.css_gradient_generator.content"
                }
            }
        };
}

sub build_test { test_zci(build_structured_answer()) }

ddg_goodie_test(
    [qw( DDG::Goodie::CssGradientGenerator )],
    'css gradient generator' => build_test(),
    'css gradient' => build_test(),
    'help gradient' => undef,
    'gradient' => undef
);

done_testing;
