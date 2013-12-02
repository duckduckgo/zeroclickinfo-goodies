#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'frequency_spectrum';

ddg_goodie_test(
        [qw(
                DDG::Goodie::FrequencySpectrum
        )],
        '50 hz' => test_zci(
'50 Hz is a radio frequency in the SLF band used by submarine communication systems.
50 Hz is also an audible frequency which can be produced by double-bass, piano, and tuba.
More at https://en.wikipedia.org/wiki/Frequency_spectrum',

          html => '50 Hz is a radio frequency in the SLF band used by submarine communication systems.<br>50 Hz is also an audible frequency which can be produced by double-bass, piano, and tuba.<br><a href="https://en.wikipedia.org/wiki/Frequency_spectrum">More at Wikipedia</a>',
          
          heading=> '50 Hz (Frequency Spectrum)'
        ),

        '400 thz' => test_zci(
'400 THz is an electromagnetic frequency of red light.
More at https://en.wikipedia.org/wiki/Frequency_spectrum',

          html => '400 THz is an electromagnetic frequency of red light.<br><a href="https://en.wikipedia.org/wiki/Frequency_spectrum">More at Wikipedia</a>',
          
          heading=> '400 THz (Frequency Spectrum)'
        ),
        
        '4 thz' => undef,
);

done_testing;