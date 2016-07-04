#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "rgbcolor";
zci is_cached   => 1;

sub build_structured_answer {
    my @test_params = @_;

    return "plain text response",
        structured_answer => {

            data => {
                title    => "My Instant Answer Title",
                subtitle => "My Subtitle",
            },

            templates => {
                group => "text",
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::RGBColor )],
    'example query' => build_test('query'),
    'bad example query' => undef,
);

done_testing;
