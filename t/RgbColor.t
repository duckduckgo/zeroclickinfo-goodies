#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "rgb_color";
zci is_cached   => 0;

sub build_structured_answer {
    my @test_params = @_;

    my %answer = build_answer_random();

    return $answer{text_answer},
        structured_answer => {

            data => $answer{data},

            templates => {
                group => "text",
            }
        };
}

my $color_re = qr/\p{XDigit}{6}/i;

sub build_answer_random {
    return (
        text_answer => re($color_re),
        data => {
            title    => re($color_re),
            subtitle => 'Random color',
        },
    );
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::RgbColor )],
    # Random colors
    'random color' => build_test(),
);

done_testing;
