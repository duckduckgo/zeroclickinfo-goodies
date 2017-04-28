#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'color_picker';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
my $goodie_version = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

sub build_structured_answer {
    my $color = shift;
    my $path = "/share/goodie/color_picker/$goodie_version/";
    return 'Color Picker',
        structured_answer => {
            data => {
                color => $color,
                saturation_value_path => "${path}saturation_value_gradient.png",
                hue_path => "${path}hue_gradient.png"
            },
            templates => {
                group => 'text',
                options => {
                    content => "DDH.color_picker.content"
                }
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::ColorPicker )],
    
    # Testing no color mentioned
    'colorpicker' => build_test(undef),
    'color picker' => build_test(undef),
    'colourpicker' => build_test(undef),
    'colour picker' => build_test(undef),
    'rgb to hex' => build_test(undef),
    'rgb to hex converter' => build_test(undef),
    'rgb to hsv' => build_test(undef),
    'rgb to hsv converter' => build_test(undef),
    'rgb to cmyk' => build_test(undef),
    'rgb to cmyk converter' => build_test(undef),
    'hex to rgb' => build_test(undef),
    'hex to rgb converter' => build_test(undef),
    'hex to hsv' => build_test(undef),
    'hex to hsv converter' => build_test(undef),
    'hex to cmyk' => build_test(undef),
    'hex to cmyk converter' => build_test(undef),
    'hsv to rgb' => build_test(undef),
    'hsv to rgb converter' => build_test(undef),
    'hsv to hex' => build_test(undef),
    'hsv to hex converter' => build_test(undef),
    'hsv to cmyk' => build_test(undef),
    'hsv to cmyk converter' => build_test(undef),
    'cmyk to rgb' => build_test(undef),
    'cmyk to rgb converter' => build_test(undef),
    'cmyk to hex' => build_test(undef),
    'cmyk to hex converter' => build_test(undef),
    'cmyk to hsv' => build_test(undef),
    'cmyk to hsv converter' => build_test(undef),
    
    # Testing Hex Color Codes Full
    'colorpicker #474747' => build_test('#474747'),
    'color picker #474747' => build_test('#474747'),
    'colourpicker #474747' => build_test('#474747'),
    'colour picker #474747' => build_test('#474747'),
    'hex to rgb #474747' => build_test('#474747'),
    'hex to rgb converter #474747' => build_test('#474747'),
    'hex to hsv #474747' => build_test('#474747'),
    'hex to hsv converter #474747' => build_test('#474747'),
    'hex to cmyk #474747' => build_test('#474747'),
    'hex to cmyk converter #474747' => build_test('#474747'),
    
    # Testing Hex Color Shorthand
    'colorpicker #474' => build_test('#474'),
    'color picker #474' => build_test('#474'),
    'colourpicker #474' => build_test('#474'),
    'colour picker #474' => build_test('#474'),
    'hex to rgb #474' => build_test('#474'),
    'hex to rgb converter #474' => build_test('#474'),
    'hex to hsv #474' => build_test('#474'),
    'hex to hsv converter #474' => build_test('#474'),
    'hex to cmyk #474' => build_test('#474'),
    'hex to cmyk converter #474' => build_test('#474'),
    
    # Testing RGB
    'colorpicker rgb(240,100,141)' => build_test('rgb,240,100,141'),
    'color picker rgb(240,100,141)' => build_test('rgb,240,100,141'),
    'colourpicker rgb(240,100,141)' => build_test('rgb,240,100,141'),
    'colour picker rgb(240,100,141)' => build_test('rgb,240,100,141'),
    'rgb to hex rgb(240,100,141)' => build_test('rgb,240,100,141'),
    'rgb to hex converter rgb(240,100,141)' => build_test('rgb,240,100,141'),
    'rgb to hsv rgb(240,100,141)' => build_test('rgb,240,100,141'),
    'rgb to hsv converter rgb(240,100,141)' => build_test('rgb,240,100,141'),
    'rgb to cmyk rgb(240,100,141)' => build_test('rgb,240,100,141'),
    'rgb to cmyk converter rgb(240,100,141)' => build_test('rgb,240,100,141'),
    
    # Testing HSV
    'colorpicker hsv(50,40,30)' => build_test('hsv,50,40,30'),
    'color picker hsv(50,40,30)' => build_test('hsv,50,40,30'),
    'colourpicker hsv(50,40,30)' => build_test('hsv,50,40,30'),
    'colour picker hsv(50,40,30)' => build_test('hsv,50,40,30'),
    'hsv to rgb hsv(50,40,30)' => build_test('hsv,50,40,30'),
    'hsv to rgb converter hsv(50,40,30)' => build_test('hsv,50,40,30'),
    'hsv to hex hsv(50,40,30)' => build_test('hsv,50,40,30'),
    'hsv to hex converter hsv(50,40,30)' => build_test('hsv,50,40,30'),
    'hsv to cmyk hsv(50,40,30)' => build_test('hsv,50,40,30'),
    'hsv to cmyk converter hsv(50,40,30)' => build_test('hsv,50,40,30'),
    
    # Testing CMYK
    'colorpicker cmyk(50,40,30,20)' => build_test('cmyk,50,40,30,20'),
    'color picker cmyk(50,40,30,20)' => build_test('cmyk,50,40,30,20'),
    'colourpicker cmyk(50,40,30,20)' => build_test('cmyk,50,40,30,20'),
    'colour picker cmyk(50,40,30,20)' => build_test('cmyk,50,40,30,20'),
    'cmyk to rgb cmyk(50,40,30,20)' => build_test('cmyk,50,40,30,20'),
    'cmyk to rgb converter cmyk(50,40,30,20)' => build_test('cmyk,50,40,30,20'),
    'cmyk to hex cmyk(50,40,30,20)' => build_test('cmyk,50,40,30,20'),
    'cmyk to hex converter cmyk(50,40,30,20)' => build_test('cmyk,50,40,30,20'),
    'cmyk to hsv cmyk(50,40,30,20)' => build_test('cmyk,50,40,30,20'),
    'cmyk to hsv converter cmyk(50,40,30,20)' => build_test('cmyk,50,40,30,20'),
    
    # Queries to ignore.
    'hello there colorpicker' => undef,
    'hello there colourpicker' => undef,
    'hello there colour picker' => undef,
    'hello there color picker' => undef,
    'testing color picker #e4e4e4' => undef,
    'testing colour picker #e4e4e4' => undef,
    'testing colourpicker #e4e4e4' => undef,
    'testing colorpicker #e4e4e4' => undef,
    'color picker download' => undef,
    'colour picker download' => undef,
    'color picker tutorial' => undef,
    'colour picker tutorial' => undef
);

done_testing;
