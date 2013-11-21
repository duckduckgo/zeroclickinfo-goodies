#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'Latex';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Latex
        )],
        'latex integral'   => test_zci('Latex integral, Command: \int_lowerbound^upperbound Usage: $\int_a^b f(x)dx$'),
        "Latex integral" => test_zci('Latex integral, Command: \int_lowerbound^upperbound Usage: $\int_a^b f(x)dx$'),
        "tex integral" => test_zci('Latex integral, Command: \int_lowerbound^upperbound Usage: $\int_a^b f(x)dx$'),
	"latex integral" => test_zci('Latex integral, Command: \int_lowerbound^upperbound Usage: $\int_a^b f(x)dx$'),
);

done_testing;
