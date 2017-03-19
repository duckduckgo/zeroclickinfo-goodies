#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'css_animations';
zci is_cached   => 1;

sub build_structured_answer {
    return 'CSS Animations',
        structured_answer => {
            id => 'css_animations',
            name => 'CSS Animations',
            data => ignore(),
            templates => {
                group => 'base',
                detail => 0,
                item_detail => 0,
                options => {
                    content => 'DDH.css_animations.content'
                },
                variants => {
                    tile => 'xwide'
                }
            }
        };
}

sub build_test { test_zci(build_structured_answer()) }

ddg_goodie_test(
    [qw( DDG::Goodie::CssAnimations )],
    'css animations' => build_test(),
    'css animations demo' => build_test(),
    'help css animations' => undef,
    'css animations generator' => undef
);

done_testing;
