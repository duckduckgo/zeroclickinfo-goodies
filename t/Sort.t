#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'sort';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Sort
        )],
        'sort -1, +4, -3, 5.7' => test_zci('-3, -1, 4, 5.7 (Sorted ascendingly)'),
        'sort [-1, +4, -3, 5.7]' => test_zci('-3, -1, 4, 5.7 (Sorted ascendingly)'),
        'sort (-1, +4, -3, 5.7)' => test_zci('-3, -1, 4, 5.7 (Sorted ascendingly)'),
        'sort desc -4.4 .5 1 66 15 -55' => test_zci('66, 15, 1, 0.5, -4.4, -55 (Sorted descendingly)'),
        'sort -3 -10 56 10' => test_zci('-10, -3, 10, 56 (Sorted ascendingly)'),
        'sort descending 10, -1, +5.3, -95, 1' => test_zci('10, 5.3, 1, -1, -95 (Sorted descendingly)'),
);

done_testing;
