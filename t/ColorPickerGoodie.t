#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'color_picker_goodie';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
my $goodie_version = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

sub build_structured_answer {
    my $color = shift;
    my $path = "/share/goodie/color_picker_goodie/$goodie_version/";
    return 'Color Picker',
        structured_answer => {
            id => 'color_picker_goodie',
            name => 'Color Picker Goodie',
            data => {
                color => $color,
                saturation_value_path => "${path}saturation_value_gradient.png",
                hue_path => "${path}hue_gradient.png"
            },
            templates => {
                group => 'text'
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::ColorPickerGoodie )],
    
    'colorpicker' => build_test(undef),
    'color picker' => build_test(undef),
    'colourpicker' => build_test(undef),
    'colour picker' => build_test(undef),
    'colorpicker #474747' => build_test('#474747'),
    
    # Queries to ignore.
    'hello there colorpicker' => undef,
    'hello there colourpicker' => undef,
    'hello there colour picker' => undef,
    'hello there color picker' => undef,
    'testing color picker #e4e4e4' => undef,
    'testing colour picker #e4e4e4' => undef,
    'testing colourpicker #e4e4e4' => undef,
    'testing colorpicker #e4e4e4' => undef,
);

done_testing;
