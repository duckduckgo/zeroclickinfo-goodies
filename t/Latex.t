#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'Latex';
zci is_cached => 0;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Latex
        )],
	"latex integral" => test_zci('Command: \int_lowerbound^upperbound
Example Usage: $\int_a^b f(x)dx$',
    		html => '<i>Command:</i> \int_lowerbound^upperbound <br> <i>Example Usage:</i> $\int_a^b f(x)dx$',
		heading => 'Latex command (integral)'),

	"Latex integral" => test_zci('Command: \int_lowerbound^upperbound
Example Usage: $\int_a^b f(x)dx$',
    		html => '<i>Command:</i> \int_lowerbound^upperbound <br> <i>Example Usage:</i> $\int_a^b f(x)dx$',
		heading => 'Latex command (integral)'),

	"tex integral" => test_zci('Command: \int_lowerbound^upperbound
Example Usage: $\int_a^b f(x)dx$',
    		html => '<i>Command:</i> \int_lowerbound^upperbound <br> <i>Example Usage:</i> $\int_a^b f(x)dx$',
		heading => 'Latex command (integral)'),
);

done_testing;
