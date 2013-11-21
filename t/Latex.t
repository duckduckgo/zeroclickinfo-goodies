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
        'latex integral'   => test_zci('<i>Command:</i> \sum_{lower}^{upper} <br> <i>Usage:</i> $\sum{i=0}^{10} x^{2}$'),
        "Latex integral" => test_zci('<i>Command:</i> \sum_{lower}^{upper} <br> <i>Usage:</i> $\sum{i=0}^{10} x^{2}$'),
        "tex integral" => test_zci('<i>Command:</i> \sum_{lower}^{upper} <br> <i>Usage:</i> $\sum{i=0}^{10} x^{2}$'),
	"latex integral" => test_zci('<i>Command:</i> \sum_{lower}^{upper} <br> <i>Usage:</i> $\sum{i=0}^{10} x^{2}$'),
);

done_testing;
