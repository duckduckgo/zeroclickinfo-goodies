#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'frequency_spectrum';

ddg_goodie_test(
    ['DDG::Goodie::FrequencySpectrum'],

    #Primary example
    '50 hz' => test_zci(
        qr/radio.+SLF.+audible.+double-bass.+piano.+tuba/,
        html => qr/radio/
    ),

    #Secondary example
    '400 thz' => test_zci(
        qr/visible.+red/,
        html => qr/visible.+red/
    ),

    #Misc
    '1,000 hz' => test_zci(
        qr/radio.+audible.+human.+voice.+viola.+violin.+guitar.+mandolin.+banjo.+piano.+saxophone.+flute.+clarinet.+oboe/,
        html => qr/radio.+/
    ),
    '1000000.99 hz' => test_zci(
        qr/radio.+MF/,
        html => qr/radio.+MF/
    ),

    #No whitespace between number and unit
    '50hz' => test_zci(
        qr/radio.+SLF.+audible.+double-bass.+piano.+tuba/,
        html => qr/radio/
    ),
    '400terahertz' => test_zci(
        qr/visible.+red/,
        html => qr/visible.+red/
    ),

    #Commas in number
    '1,000,000.99 hz' => test_zci(
        qr/radio.+MF/,
        html => qr/radio.+MF/
    ),

    #Should not trigger
    '1000.000..99 hz' => undef,
    '4 thz' => undef,
);

done_testing;
