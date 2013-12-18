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
	"latex integral" => test_zci('LaTeX command: \int_lowerbound^upperbound
Example: $\int_a^b f(x)dx$',
    		html => qr/\\int_lowerbound\^upperbound/,
		heading => 'Integral (LaTeX)'),

	"tex integral" => test_zci('LaTeX command: \int_lowerbound^upperbound
Example: $\int_a^b f(x)dx$',
		html => qr/\\int_lowerbound\^upperbound/,
		heading => 'Integral (LaTeX)'),
);

done_testing;
