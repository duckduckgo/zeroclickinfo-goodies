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
        data        => {
            subtitle_prefix => 'Mix ',
            %params,
        }
    );
}

sub build_answer_random {
    my %params = @_;
    return (
        text_answer => re($color_re),
        data        => {
            result_color    => re($color_re),
            subtitle_prefix => 'Random color between ',
            %params,
        },
    );
}

sub build_structured_answer {
    my ($type, %test_params) = @_;
    my $builder = $test_builders{$type};
    my %answer = $builder->(%test_params);

    return $answer{text_answer},
        structured_answer => {

            data => $answer{data},

            templates => {
                group   => "text",
                options => {
                    title_content    => 'DDH.rgb_color.title_content',
                    subtitle_content => 'DDH.rgb_color.sub_list',
                },
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

################
#  Test Cases  #
################

my $tc_mix_black_white = build_test('mix',
    input_colors => ['#000000', '#ffffff'],
    result_color => '#7f7f7f',
);

my $tc_random_black_white = build_test('random',
    input_colors => ['#000000', '#ffffff'],
);

my $tc_random_white_black = build_test('random',
    input_colors => ['#ffffff', '#000000'],
);

ddg_goodie_test(
    [qw( DDG::Goodie::RgbColor )],
    # Random colors
    'random color' => $tc_random_black_white,
    'rand color'   => $tc_random_black_white,
    # # With bounds
    'random color between white and black' => $tc_random_white_black,
    # # # W/o 'and'
    'random color between black white' => $tc_random_black_white,
    # Using 'colour'
    'random colour' => $tc_random_black_white,
    # Mixing colors
    'mix 000000 ffffff' => $tc_mix_black_white,
    # # With leading '#'
    'mix #000000 #ffffff' => $tc_mix_black_white,
    # # 'and'
    'mix 000000 and ffffff' => $tc_mix_black_white,
    # # Using names
    'mix black and white' => $tc_mix_black_white,
    # Invalid queries
    'color'               => undef,
    'color ffffff'        => undef,
    'color picker'        => undef,
    'color picker ffffff' => undef,
);

done_testing;
