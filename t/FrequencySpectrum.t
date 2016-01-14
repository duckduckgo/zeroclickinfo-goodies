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
        structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
    ),

    #Secondary example
    '400 thz' => test_zci(
        qr/infrared/,
        structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
    ),

    #Misc
    '1,000 hz' => test_zci(
      #qr/radio.+audible.+human.+voice.+viola.+violin.+guitar.+mandolin.+banjo.+piano.+saxophone.+flute.+clarinet.+oboe/,
      qr/radio/,
      structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
    ),
    '1000000.99 hz' => test_zci(
        qr/radio.+MF/,
        structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
    ),
    '29.1 hz' => test_zci(
        qr/radio.+ELF/,
        structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
    ),

    #No whitespace between number and unit
    '50hz' => test_zci(
      #qr/radio.+SLF.+audible.+double-bass.+piano.+tuba/,
        qr/radio/,
        structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
    ),
    '400terahertz' => test_zci(
        qr/infrared/,
        structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
    ),

    #Mixed case
    '400 THz' => test_zci(
        qr/infrared/,
        structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
    ),

    '1000 HZ' => test_zci(
      #qr/radio.+audible.+human.+voice.+viola.+violin.+guitar.+mandolin.+banjo.+piano.+saxophone.+flute.+clarinet.+oboe/,
      qr/radio/,
      structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
    ),

    #Commas in number
    '1,000,000.99 hz' => test_zci(
        qr/radio.+MF/,
        structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
    ),

    #Can you test with all the colours of the wind?
    '650 nm' => test_zci(
        qr/visible.+red/,
        structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
    ),
    '610 nanometers' => test_zci(
        qr/visible.+orange/,
        structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
    ),
    '580 nanometres' => test_zci(
        qr/visible.+yellow/,
        structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
    ),
    '536 nanometer' => test_zci(
        qr/visible.+green/,
        structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
    ),
    '478.1 nm' => test_zci(
        qr/visible.+blue/,
        structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
    ),
    '380.000000000 nanometres' => test_zci(
        qr/visible.+violet/,
        structured_answer => {
            id => 'frequency_spectrum',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.frequency_spectrum.content'
                }
            }
        }
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
