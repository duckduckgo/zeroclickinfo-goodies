#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'frequency_spectrum';
zci is_cached   => 1;

ddg_goodie_test(
    ['DDG::Goodie::FrequencySpectrum'],
    '50 hz' => test_zci(
	'50 Hz is a radio frequency in the SLF band used by submarine communication systems.
50 Hz is also an audible frequency which can be produced by double-bass, piano, and tuba.
More at https://en.wikipedia.org/wiki/Musical_acoustics',
	html => "50 Hz is a radio frequency in the SLF band used by submarine communication systems.<br>50 Hz is also an audible frequency which can be produced by double-bass, piano, and tuba.<br><a href='https://en.wikipedia.org/wiki/Musical_acoustics'>More at Wikipedia</a>",
	heading => '50 Hz (Frequency Spectrum)'
    ),

    '400 thz' => test_zci(
	'400 THz is an electromagnetic frequency of red light.
More at https://en.wikipedia.org/wiki/Color',
	html => "400 THz is an electromagnetic frequency of red light.<br><a href='https://en.wikipedia.org/wiki/Color'>More at Wikipedia</a>",
	heading => '400 THz (Frequency Spectrum)'
    ),

    '4 thz' => undef,

    '1,000 hz' => test_zci(
	'1 kHz is a radio frequency in the ULF band used by mine cave communication systems.
1 kHz is also an audible frequency which can be produced by human voice, viola, violin, guitar, mandolin, banjo, piano, saxophone, flute, clarinet, and oboe.
More at https://en.wikipedia.org/wiki/Musical_acoustics',
	html => "1 kHz is a radio frequency in the ULF band used by mine cave communication systems.<br>1 kHz is also an audible frequency which can be produced by human voice, viola, violin, guitar, mandolin, banjo, piano, saxophone, flute, clarinet, and oboe.<br><a href='https://en.wikipedia.org/wiki/Musical_acoustics'>More at Wikipedia</a>",
	heading => '1 kHz (Frequency Spectrum)'
    ),

    '1000000.99 hz' => test_zci(
	'1.00000099 MHz is a radio frequency in the MF band used by AM broadcasts, navigation systems, and ship-to-shore communication systems.
More at https://en.wikipedia.org/wiki/Radio_spectrum',
	html => "1.00000099 MHz is a radio frequency in the MF band used by AM broadcasts, navigation systems, and ship-to-shore communication systems.<br><a href='https://en.wikipedia.org/wiki/Radio_spectrum'>More at Wikipedia</a>",
	heading => '1.00000099 MHz (Frequency Spectrum)',
    ),

    '1000.000..99 hz' => undef,
);

done_testing;
