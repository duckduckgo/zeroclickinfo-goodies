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
            # Ignoring data here is good because if there is some new color
            # added to the library in future, all the tests will break
            data => ignore(),
            templates => {
                group => 'list',
                options => {
                    list_content => 'DDH.css_colors.content'
                }
            },
            meta => {
                sourceName => 'Mozilla Developer Network',
                sourceUrl => 'https://developer.mozilla.org/en-US/docs/Web/CSS/color_value#Color_keywords'
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::CssColors )],

    'css colors' => build_test(),
    'css3 colors' => build_test(),
    'css named colors' => build_test(),
    'css3 named colors' => build_test(),
    'named css colors' => build_test(),
    'named css3 colors' => build_test(),
    'named colors css' => build_test(),
    'named colors css3' => build_test(),
    'css colours' => build_test(),
    'css3 colours' => build_test(),
    'css named colours' => build_test(),
    'css3 named colours' => build_test(),
    'named css colours' => build_test(),
    'named css3 colours' => build_test(),
    'named colours css' => build_test(),
    'named colours css3' => build_test(),

    'how many named css3 colors are there' => undef,
    'color picker' => undef,
    'css tutorial' => undef,
    'css forum' => undef,
    'colors tv' => undef,
    'css colors tutorial' => undef,
    'css colors that go together' => undef,
    'css colors words' => undef,
);

done_testing;
