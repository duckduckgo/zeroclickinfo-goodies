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
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries:
     '1Hz wavelength' => test_zci("1 Hz λ = 299792458 Meters"),
    'lambda 0.001kHz' => test_zci('0.001 kHz λ = 299792458 Meters'),

    'λ 2.4GHz' => test_zci('1 Hz λ = 299792458 Meters'),
    #'144.39 MHz wavelength' => test_zci(''),
    #'lambda 1500kHz' => test_zci(''),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'lambda lambda lambda' => undef,
);

done_testing;
