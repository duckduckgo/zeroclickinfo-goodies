#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'csscolors';
zci is_cached   => 1;

sub build_structured_answer {

    return 'CSS Colors',
        structured_answer => {

            data => ignore(),

            templates => {
                group => 'list',
                options => {
                    list_content => 'DDH.css_colors.content'
                }
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::CssColors )],

    'css colors' => build_test(),

    'color picker' => undef,
);

done_testing;
