#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'sig_figs';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::SigFigs
        )],
        'sf 78' => test_zci('Significant figures: 2'),
);

done_testing;
