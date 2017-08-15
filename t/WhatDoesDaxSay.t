#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'what_does_dax_say';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my @test_params = @_;

    return '',
        structured_answer => {
            id => "what_does_dax_say",

            data => ignore(),

            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.what_does_dax_say.content'
                }
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::WhatDoesDaxSay )],

    'what does dax say' => build_test(),
    'what does the dax say' => build_test(),
    'what does the fox say' => undef,
    'daxsays hi' => undef,
);

done_testing;
