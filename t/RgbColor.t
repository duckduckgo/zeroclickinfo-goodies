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
    reverse => \&build_answer_reverse,
    tint => \&build_answer_tint,
);

my $color_re = qr/^\p{XDigit}{6}$/i;

sub build_standard_builder {
    my $subtitle_prefix = shift;
    return sub {
        my %params = @_;
        return (
            text_answer => $params{result_color}->{hex},
            data        => {
                subtitle_prefix => $subtitle_prefix,
                %params,
            }
        );
    };
}

sub build_answer_mix {
    my %params = @_;
    my $inps = $params{input_colors};
    do {
        my $i = 0;
        map { $inps->[$i] = { amount => 0.5, %{$_} }; $i++ }
            @{$params{input_colors}}
    };
    $params{input_colors} = $inps;

    build_standard_builder('Mix')->(%params);
}

sub build_answer_tint {
    my %params = @_;
    my $inps = $params{input_colors};
    do {
        my $i = 1;
        my @inps = @{$params{input_colors}};
        map { $inps->[$i] = { amount => 0.5, %{$_} }; $i++ }
            @inps[1..$#inps];
    };
    $params{input_colors} = $inps;

    build_standard_builder('Tint')->(%params);
}

sub build_answer_random {
    my %params = @_;
    return (
        text_answer => re($color_re),
        data        => {
            result_color    => superhashof({
                hex => re($color_re)
            }),
            subtitle_prefix => 'Random color between',
            %params,
        },
    );
}

sub build_answer_reverse {
    build_standard_builder('(RGB) Opposite color of')->(@_);
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
                    content => 'DDH.rgb_color.content',
                },
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

################
#  Test Cases  #
################

my $black = {
    hex       => '000000',
    name      => 'black',
    title     => 'Black',
    cmyb_disp => 'CMYB(0%, 0%, 0%, 100%)',
    hex_disp  => 'Hex: #000000',
    hslc_disp => 'HSL(0, 0%, 0%)',
    rgb_disp  => 'RGB(0, 0, 0)',
};

my $black_9prt = { %$black, amount => 0.9 };

my $black_1prt = { %$black, amount => 1 };

my $white = {
    hex       => 'ffffff',
    name      => 'white',
    title     => 'White',
    cmyb_disp => 'CMYB(0%, 0%, 0%, 0%)',
    hex_disp  => 'Hex: #FFFFFF',
    hslc_disp => 'HSL(0, 0%, 100%)',
    rgb_disp  => 'RGB(255, 255, 255)',
};

my $white_1prt = { %$white, amount => 0.1 };

my $white_0prt = { %$white, amount => 0 };

my $grey = {
    hex       => '7f7f7f',
    name      => 'grey50',
    title     => 'Grey50',
    cmyb_disp => 'CMYB(0%, 0%, 0%, 50%)',
    hex_disp  => 'Hex: #7F7F7F',
    hslc_disp => 'HSL(0, 0%, 50%)',
    rgb_disp  => 'RGB(127, 127, 127)',
};

my $black_9_white_1 = {
    hex       => '191919',
    name      => '',
    title     => '',
    cmyb_disp => 'CMYB(0%, 0%, 0%, 90%)',
    hex_disp  => 'Hex: #191919',
    hslc_disp => 'HSL(0, 0%, 10%)',
    rgb_disp  => 'RGB(25, 25, 25)',
};

my $blue = {
    hex       => '0000ff',
    name      => 'blue',
    title     => 'Blue',
    cmyb_disp => 'CMYB(100%, 100%, 0%, 0%)',
    hex_disp  => 'Hex: #0000FF',
    hslc_disp => 'HSL(240, 100%, 50%)',
    rgb_disp  => 'RGB(0, 0, 255)',
};

my $blue1 = { %$blue, name => 'blue1', title => 'Blue1' };

my $yellow = {
    hex       => 'ffff00',
    name      => 'yellow',
    title     => 'Yellow',
    cmyb_disp => 'CMYB(0%, 0%, 100%, 0%)',
    hex_disp  => 'Hex: #FFFF00',
    hslc_disp => 'HSL(60, 100%, 50%)',
    rgb_disp  => 'RGB(255, 255, 0)',
};

my $dark_spring_yellow = {
    hex       => '669900',
    name      => 'darkspringyellow',
    title     => 'Dark Spring-Yellow',
    cmyb_disp => 'CMYB(33%, 0%, 100%, 40%)',
    hex_disp  => 'Hex: #669900',
    hslc_disp => 'HSL(80, 100%, 30%)',
    rgb_disp  => 'RGB(102, 153, 0)',
};

my $light_violet_blue = {
    hex       => '9966ff',
    name      => 'lightvioletblue',
    title     => 'Light Violet-Blue',
    cmyb_disp => 'CMYB(40%, 60%, 0%, 0%)',
    hex_disp  => 'Hex: #9966FF',
    hslc_disp => 'HSL(260, 100%, 70%)',
    rgb_disp  => 'RGB(153, 102, 255)',
};

my $sap_green = {
    hex       => 'bdda57',
    name      => 'sapgreen',
    title     => 'Sap green',
    cmyb_disp => 'CMYB(13%, 0%, 60%, 15%)',
    hex_disp  => 'Hex: #BDDA57',
    hslc_disp => 'HSL(73, 64%, 60%)',
    rgb_disp  => 'RGB(189, 218, 87)',
};

my $sap_green_opp = {
    hex       => '4225a8',
    name      => '',
    title     => '',
    cmyb_disp => 'CMYB(61%, 78%, 0%, 34%)',
    hex_disp  => 'Hex: #4225A8',
    hslc_disp => 'HSL(253, 64%, 40%)',
    rgb_disp  => 'RGB(66, 37, 168)',
};

my $tc_mix_black_white = build_test('mix',
    input_colors => [$black, $white],
    result_color => $grey,
);

my $tc_mix_black_white_9_1 = build_test('mix',
    input_colors => [$black_9prt, $white_1prt],
    result_color => $black_9_white_1,
);

my $tc_mix_black_white_1_0 = build_test('mix',
    input_colors => [$black_1prt, $white_0prt],
    result_color => $black,
);

my $tc_random_black_white = build_test('random',
    input_colors => [$black, $white],
);

my $tc_random_white_black = build_test('random',
    input_colors => [$white, $black],
);

my $tc_opp_white = build_test('reverse',
    input_colors => [$white],
    result_color => $black,
);

my $tc_opp_blue = build_test('reverse',
    input_colors => [$blue],
    result_color => $yellow,
);

my $tc_opp_blue1 = build_test('reverse',
    input_colors => [$blue1],
    result_color => $yellow,
);

my $tc_opp_dsy = build_test('reverse',
    input_colors => [$dark_spring_yellow],
    result_color => $light_violet_blue,
);

my $tc_opp_sg = build_test('reverse',
    input_colors => [$sap_green],
    result_color => $sap_green_opp,
);

my $tc_tint_black_white = build_test('tint',
    input_colors => [$black, $white],
    result_color => $black,
);

my $tc_tint_white_black = build_test('tint',
    input_colors => [$white, $black],
    result_color => $grey,
);

my $tc_tint_white_black_100 = build_test('tint',
    input_colors => [$white, $black_1prt],
    result_color => $black,
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
    # Plural (even though it isn't)
    'random colors' => $tc_random_black_white,
    # Mixing colors
    'mix 000000 ffffff'     => $tc_mix_black_white,
    'black and white mixed' => $tc_mix_black_white,
    'mix black with white'  => $tc_mix_black_white,
    # 'addition' form
    'mix black + white' => $tc_mix_black_white,
    'black + white ='   => $tc_mix_black_white,
    # # With amounts
    'mix 9 parts black with 1 part white' => $tc_mix_black_white_9_1,
    'mix 90% black and 10% white'         => $tc_mix_black_white_9_1,
    'mix 100% black and 0% white'         => $tc_mix_black_white_1_0,
    # # # Division by zero
    'mix 0 parts black with 0 parts white' => undef,
    # # With leading '#'
    'mix #000000 #ffffff' => $tc_mix_black_white,
    # # 'and'
    'mix 000000 and ffffff' => $tc_mix_black_white,
    # # Using names
    'mix black and white' => $tc_mix_black_white,
    # Reversing colors
    'opposite of white'            => $tc_opp_white,
    'complementary color of white' => $tc_opp_white,
    'complement white'             => $tc_opp_white,
    'opposite color for white'     => $tc_opp_white,
    # # Using three-digit hex
    'opposite of #690' => $tc_opp_dsy,
    # # # Must be three or six digits
    'opposite of #6901' => undef,
    # Tinting colors
    'tint black with white'      => $tc_tint_black_white,
    'tint white with black'      => $tc_tint_white_black,
    'tint white with 100% black' => $tc_tint_white_black_100,
    # Advanced colors (non-WWW)
    'opposite of darkspringyellow'   => $tc_opp_dsy,
    'opposite of dark spring-yellow' => $tc_opp_dsy,
    'opposite of blue1'              => $tc_opp_blue1,
    # # W/ alternate forms
    'opposite of sapgreen'  => $tc_opp_sg,
    'opposite of sap-green' => $tc_opp_sg,
    'opposite of sap green' => $tc_opp_sg,
    # Sample queries (from checking query suggestions)
    'mix black and white what color do you get'   => $tc_mix_black_white,
    'what do you get if you mix black and white'  => $tc_mix_black_white,
    'what do you get if you mix black and white?' => $tc_mix_black_white,
    "what's opposite of blue on the color wheel"  => $tc_opp_blue,
    'mixing black and white makes what color'     => $tc_mix_black_white,
    'mixing black and white makes what'           => $tc_mix_black_white,
    'black mixed with white'                      => $tc_mix_black_white,
    'black tinted with white'                     => $tc_tint_black_white,
    # Invalid queries
    'color'               => undef,
    'color ffffff'        => undef,
    'color picker'        => undef,
    'color picker ffffff' => undef,
    'mix'                 => undef,
    # # From sample queries
    'random color names'                            => undef,
    'mix colors to make black'                      => undef,
    'how to mix concrete'                           => undef,
    'blue and gold dress'                           => undef,
    'opposite of blue raining jane lyrics'          => undef,
    'pictures of blue rain'                         => undef,
    'blue hex color'                                => undef,
    'complement girl'                               => undef,
    'red and blue mixed up spiderman action figure' => undef,
    'red and blue mixed pitbulls'                   => undef,
    'red + blue light'                              => undef,
    'red + blue bedding'                            => undef,
    # # With potential to trigger in the future
    'blue and gold' => undef,

);

done_testing;
