#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'golden_ratio';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::GoldenRatio
        )],
        'golden ratio 1:?' => test_zci('Golden ratio: 1 : 1.61803398874989'),
);

done_testing;
