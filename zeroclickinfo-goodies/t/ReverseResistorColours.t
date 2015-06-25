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

	'black green red resistor'
        => test_zci('A black green red resistor has a resistance of 500 Ω ± 20%.',
                html => 'A black green red resistor has a resistance of 500 Ω ± 20%. '
                    . '<a href="https://en.wikipedia.org/wiki/Electronic_color_code">More at Wikipedia</a>'),
	'red orange yellow gold resistor'
        => test_zci('A red orange yellow gold resistor has a resistance of 230 kΩ ± 5%.',
                html => 'A red orange yellow gold resistor has a resistance of 230 kΩ ± 5%. '
                    . '<a href="https://en.wikipedia.org/wiki/Electronic_color_code">More at Wikipedia</a>'),
	'resistor yellow blue purple'
        => test_zci('A yellow blue violet resistor has a resistance of 460 MΩ ± 20%.',
                html => 'A yellow blue violet resistor has a resistance of 460 MΩ ± 20%. '
                    . '<a href="https://en.wikipedia.org/wiki/Electronic_color_code">More at Wikipedia</a>'),

	'resistor yellow green' => undef,
	'resistor red orange blue red green' => undef,
	'resistor red banana orangutan' => undef,
    'red yellow white gold resistor' => test_zci(
        'A red yellow white gold resistor has a resistance of 24 GΩ ± 5%.',
        html => 'A red yellow white gold resistor has a resistance of 24 GΩ ± 5%. <a href="https://en.wikipedia.org/wiki/Electronic_color_code">More at Wikipedia</a>'
    ),
    'resistor red yellow white' => test_zci(
        'A red yellow white resistor has a resistance of 24 GΩ ± 20%.',
        html => 'A red yellow white resistor has a resistance of 24 GΩ ± 20%. <a href="https://en.wikipedia.org/wiki/Electronic_color_code">More at Wikipedia</a>'
    ),
);

done_testing;
