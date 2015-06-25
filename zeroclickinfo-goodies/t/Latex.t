#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'Latex';
zci is_cached   => 1;

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
    'latex summation' => test_zci('LaTeX command: \sum_{lower}^{upper}
Example: $\sum{i=0}^{10} x^{2}$',
		html => qr/\\sum_\{lower\}\^\{upper\}/,
        heading => 'Summation (LaTeX)'),
);

done_testing;
