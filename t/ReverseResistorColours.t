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
	'black green red resistor' => test_zci("A black green red resistor has a resistance of 500 Ω ± 20%."),
	'red orange yellow gold resistor' => test_zci("A red orange yellow gold resistor has a resistance of 230 kΩ ± 5%."),
	'resistor yellow blue purple' => test_zci("A yellow blue violet resistor has a resistance of 460 MΩ ± 20%."),
	'resistor yellow green' => undef,
	'resistor red orange blue red green' => undef,
	'resistor red banana orangutan' => undef
);

done_testing;
