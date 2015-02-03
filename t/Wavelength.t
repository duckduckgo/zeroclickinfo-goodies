#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => "wavelength";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Wavelength )],
    '1Hz wavelength' => test_zci("1 Hz λ = 299792458 Meters"),
    'lambda 0.001kHz' => test_zci("0.001 kHz λ = 299792458 Meters"),
    "λ 2400MHz" => test_zci("2400 MHz λ = 12.4913524166667 Centimeters"),
    "λ 2.4GHz" => test_zci("2.4 GHz λ = 12.4913524166667 Centimeters"),
    '144.39 MHz wavelength' => test_zci('144.39 MHz λ = 2.0762688413325 Meters'),
    'lambda 1500kHz' => test_zci('1500 kHz λ = 199.861638666667 Meters'),
    'lambda lambda lambda' => undef,
);

done_testing;
