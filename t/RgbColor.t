#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "rgb_color";
zci is_cached   => 0;

###################
#  Test Builders  #
###################

my %test_builders = (
    mix    => \&build_answer_mix,
    random => \&build_answer_random,
);

my $color_re = qr/^#\p{XDigit}{6}$/i;

sub build_answer_mix {
    my %params = @_;
    return (
        text_answer => $params{result_color},
        data        => \%params,
        options     => {
            subtitle_content => 'DDH.rgb_color.mix',
        },
    );
}

sub build_answer_random {
    return (
        text_answer => re($color_re),
        data => {
            result_color => re($color_re),
            subtitle     => 'Random color',
        },
    );
}

sub build_structured_answer {
    my ($type, %test_params) = @_;
    my $builder = $test_builders{$type};
    my %answer = $builder->(%test_params);

    $answer{options} //= {};
    return $answer{text_answer},
        structured_answer => {

            data => $answer{data},

            templates => {
                group   => "text",
                options => {
                    title_content => 'DDH.rgb_color.title_content',
                    %{$answer{options}},
                },
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

################
#  Test Cases  #
################

my $tc_mix_white_black = build_test('mix',
    input_colors => ['#000000', '#ffffff'],
    result_color => '#7f7f7f',
);

ddg_goodie_test(
    [qw( DDG::Goodie::RgbColor )],
    # Random colors
    'random color' => build_test('random'),
    'rand color'   => build_test('random'),
    # Using 'colour'
    'random colour' => build_test('random'),
    # Mixing colors
    'mix 000000 ffffff' => $tc_mix_white_black,
    # # With leading '#'
    'mix #000000 #ffffff' => $tc_mix_white_black,
    # Invalid queries
    'color'               => undef,
    'color ffffff'        => undef,
    'color picker'        => undef,
    'color picker ffffff' => undef,
);

done_testing;
