#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'cssanimations';
zci is_cached   => 1;

sub build_structured_answer {
    return 'CSS Animations',
        structured_answer => {
            id => 'cssanimations',
            name => 'CSS Animations',
            data => ignore(),
            templates => {
                group => 'text',
                detail => 0,
                item_detail => 0,
                options => {
                    footer => 'DDH.cssanimations.footer'
                },
                variants => {
                    tileSnippet => 'large'
                }
            }
        };
}

sub build_test { test_zci(build_structured_answer()) }

ddg_goodie_test(
    [qw( DDG::Goodie::CSSAnimations )],
    'css animations' => build_test(),
    'help css animations' => undef,
);

done_testing;
