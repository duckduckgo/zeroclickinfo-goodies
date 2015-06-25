#!/usr/bin/env perl

# NOTE: Audible frequency results are currently being suppressed,
# as the resulting IA is too long. This will be revisited when
# better stying is available.

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'frequency_spectrum';
zci is_cached   => 1;

ddg_goodie_test(
    ['DDG::Goodie::FrequencySpectrum'],

    #Primary example
    '50 hz' => test_zci(
      #qr/radio.+SLF.+audible.+double-bass.+piano.+tuba/,
        qr/radio/,
        html => qr/radio/
    ),

    #Secondary example
    '400 thz' => test_zci(
        qr/infrared/,
        html => qr/infrared/
    ),

    #Misc
    '1,000 hz' => test_zci(
      #qr/radio.+audible.+human.+voice.+viola.+violin.+guitar.+mandolin.+banjo.+piano.+saxophone.+flute.+clarinet.+oboe/,
      qr/radio/,
        html => qr/radio.+/
    ),
    '1000000.99 hz' => test_zci(
        qr/radio.+MF/,
        html => qr/radio.+MF/
    ),
    '29.1 hz' => test_zci(
        qr/radio.+ELF/,
        html => qr/radio.+ELF/
    ),

    #No whitespace between number and unit
    '50hz' => test_zci(
      #qr/radio.+SLF.+audible.+double-bass.+piano.+tuba/,
        qr/radio/,
        html => qr/radio/
    ),
    '400terahertz' => test_zci(
        qr/infrared/,
        html => qr/infrared/
    ),

    #Mixed case
    '400 THz' => test_zci(
        qr/infrared/,
        html => qr/infrared/
    ),

    '1000 HZ' => test_zci(
      #qr/radio.+audible.+human.+voice.+viola.+violin.+guitar.+mandolin.+banjo.+piano.+saxophone.+flute.+clarinet.+oboe/,
      qr/radio/,
        html => qr/radio.+/
    ),

    #Commas in number
    '1,000,000.99 hz' => test_zci(
        qr/radio.+MF/,
        html => qr/radio.+MF/
    ),

    #Can you test with all the colours of the wind?
    '650 nm' => test_zci(
        qr/visible.+red/,
        html => qr/visible.+red/
    ),
    '610 nanometers' => test_zci(
        qr/visible.+orange/,
        html => qr/visible.+orange/
    ),
    '580 nanometres' => test_zci(
        qr/visible.+yellow/,
        html => qr/visible.+yellow/
    ),
    '536 nanometer' => test_zci(
        qr/visible.+green/,
        html => qr/visible.+green/
    ),
    '478.1 nm' => test_zci(
        qr/visible.+blue/,
        html => qr/visible.+blue/
    ),
    '380.000000000 nanometres' => test_zci(
        qr/visible.+violet/,
        html => qr/visible.+violet/
    ),

    #Only visible light wavelengths should trigger 
    '0.1 nm' => undef,
    '100 nm' => undef,
    '800 nm' => undef,
    '10000 nm' => undef,

    #Malformed frequencies/wavelengths should not trigger
    '1000.000..99 hz' => undef,
    '15 kilo hertz' => undef,
    '100,123 jiggahz' => undef,
    'hertz' => undef,
    'terahz' => undef,
    '600 nmeters' => undef,
);

done_testing;
