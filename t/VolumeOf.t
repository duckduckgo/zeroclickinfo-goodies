#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "volume_of";
zci is_cached   => 1;

my %volumes;
$volumes{'cube'} = "s^3";
$volumes{'rectangular prism'} = "lwh";
$volumes{'rectangular solid'} = "lwh";
$volumes{'sphere'} = "\\frac{4}{3} \\pi r^3";
$volumes{'cylinder'} = "\\pi r^2h";
$volumes{'cone'} = "\\frac{1}{3} \\pi r^2h";
$volumes{'square pyramid'} = "\\frac{1}{3} s^2h";
$volumes{'triangular pyramid'} = "\\frac{1}{3} (\\frac{1}{2} b h_1)h_2"; 
$volumes{'triangular-based pyramid'} = "\\frac{1}{3} (\\frac{1}{2} b h_1)h_2"; 
$volumes{'triangular based pyramid'} = "\\frac{1}{3} (\\frac{1}{2} b h_1)h_2"; 
$volumes{'pyramid'} = "\\frac{lwh}{3}";
$volumes{'triangular prism'} = "\\frac{1}{4} h \\sqrt{-a^4 +2(ab)^2 +2(ac)^2 - b^4 + 2(bc)^2 - c^4}";
# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my @test_object = @_;

    return "plain text response",
        structured_answer => {
            id => "volume_of",
            name => "Answer",
            data => {
                title    => "Volume Of A " . ucfirst($test_object[0]), 
                answer => "V = " . $volumes{lc($test_object[0])},
            },

            templates => {
                group => "text",
                options => {
                    subtitle_content => 'DDH.volume_of.subtitle'
                }
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::VolumeOf )],
    
    # Testing normal queries
    'volume of a cube' => build_test('cube'),
    'volume of a rectangular prism' => build_test('rectangular prism'),
    'volume of a sphere' => build_test('sphere'),
    'volume of a pyramid' => build_test('pyramid'),
    
    # Testing odd format queries
    'volume of a Sphere' => build_test('sphere'),
    'volume of a SPHERE' => build_test('sphere'),
    'volume of sphere' => build_test('sphere'),
    'volume sphere' => build_test('sphere'),
    
    # Testing non executed queries 
    'volume of a banana' => undef,
    'volume' => undef,
    'volume orange' => undef,
    'volume of apple' => undef,
);

done_testing;
