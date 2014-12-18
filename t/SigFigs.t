#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'sig_figs';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::SigFigs
        )],
        'sf 78' => test_zci('Significant figures: 2'),
        "sigfigs 10.12404" => test_zci("Significant figures: 7"),
        "sigdigs 3030." => test_zci("Significant figures: 4"),
        "significant figures 0.0100235" => test_zci("Significant figures: 6"),
        "sf 302.056" => test_zci("Significant figures: 6"),
        "sd 045.30" => test_zci("Significant figures: 4"),
        'sigfigs 01.1234000' => test_zci('Significant figures: 8'),
        'significant figures 000123000' => test_zci('Significant figures: 3'),
);

done_testing;
