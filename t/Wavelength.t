#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use utf8;

zci answer_type => "wavelength";
zci is_cached   => 1;

sub build_test {
    my ($freq_value, $wave_value, $freq_units, $wave_units, $vf_text) = @_;

    my $expect = "λ = $wave_value $wave_units";
    return test_zci($expect, structured_answer => {
        data => {
            title => $expect,
            subtitle => "Wavelength of $freq_value $freq_units (${vf_text}Speed of light in a vacuum)"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Wavelength )],
    '1Hz wavelength'        => build_test(1, 299792458,'Hz', "Meters", ""),
    '1 MHz lambda VF=0.85'  => build_test(1, 254.8235893,'MHz','Meters', "0.85 × "),
    'lambda 0.001kHz'       => build_test(0.001, 299792458,'kHz', "Meters", ""),
    "λ 2400MHz"             => build_test(2400, 12.4913524166667, 'MHz', 'Centimeters', ""),
    "λ 2.4GHz"              => build_test(2.4, 12.4913524166667, 'GHz', 'Centimeters', ""),
    '144.39 MHz wavelength' => build_test(144.39, 2.0762688413325, 'MHz', "Meters", ""),
    'lambda 1500kHz'        => build_test(1500, 199.861638666667, 'kHz', "Meters", ""),
    'lambda lambda lambda'  => undef,
);

done_testing;