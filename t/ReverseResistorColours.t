#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci is_cached => 1;
zci answer_type => 'ohms';

ddg_goodie_test(
    [qw(
        DDG::Goodie::ReverseResistorColours
    )],

    'black green red resistor' => test_zci(
        'A black green red resistor has a resistance of 500 Ω ± 20%.',
        structured_answer => {
            data => {
                title => '500 Ω ± 20%',
                subtitle => 'Resistance of black green red resistor'
            },
            meta => {
                sourceName => "Wikipedia",
                sourceUrl => "https://en.wikipedia.org/wiki/Electronic_color_code",
            },
            templates => {
                group => 'text',
                options => {          
                    moreAt => 1,
                }
            }
        }
    ),
    'red orange yellow gold resistor' => test_zci(
        'A red orange yellow gold resistor has a resistance of 230 kΩ ± 5%.',
        structured_answer => {
            data => {
                title => '230 kΩ ± 5%',
                subtitle => 'Resistance of red orange yellow gold resistor'
            },
            meta => {
                sourceName => "Wikipedia",
                sourceUrl => "https://en.wikipedia.org/wiki/Electronic_color_code",
            },
            templates => {
                group => 'text',
                options => {          
                    moreAt => 1,
                }
            }
        }
    ),
    'resistor yellow blue purple'=> test_zci(
        'A yellow blue violet resistor has a resistance of 460 MΩ ± 20%.',
         structured_answer => {
            data => {
                title => '460 MΩ ± 20%',
                subtitle => 'Resistance of yellow blue violet resistor'
            },
            meta => {
                sourceName => "Wikipedia",
                sourceUrl => "https://en.wikipedia.org/wiki/Electronic_color_code",
            },
            templates => {
                group => 'text',
                options => {          
                    moreAt => 1,
                }
            }
        }
    ),

    'resistor yellow green' => undef,
    'resistor red orange blue red green' => undef,
    'resistor red banana orangutan' => undef,
    'red yellow white gold resistor' => test_zci(
        'A red yellow white gold resistor has a resistance of 24 GΩ ± 5%.',
        structured_answer => {
            data => {
                title => '24 GΩ ± 5%',
                subtitle => 'Resistance of red yellow white gold resistor'
            },
            meta => {
                sourceName => "Wikipedia",
                sourceUrl => "https://en.wikipedia.org/wiki/Electronic_color_code",
            },
            templates => {
                group => 'text',
                options => {          
                    moreAt => 1,
                }
            }
        }
    ),
    'resistor red yellow white' => test_zci(
        'A red yellow white resistor has a resistance of 24 GΩ ± 20%.',
        structured_answer => {
            data => {
                title => '24 GΩ ± 20%',
                subtitle => 'Resistance of red yellow white resistor'
            },
            meta => {
                sourceName => "Wikipedia",
                sourceUrl => "https://en.wikipedia.org/wiki/Electronic_color_code",
            },
            templates => {
                group => 'text',
                options => {          
                    moreAt => 1,
                }
            }
        }
    ),
);

done_testing;
