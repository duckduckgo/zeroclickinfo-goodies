#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci is_cached => 1;
zci answer_type => 'sum';

ddg_goodie_test(
    [
        'DDG::Goodie::SumOfNaturalNumbers'
    ],
    'sum 1 to 10' => test_zci('Sum of natural numbers from 1 to 10 is 55.'),
    'sum 55 to 63' => test_zci('Sum of natural numbers from 55 to 63 is 531.'),
    'add 33 to 100' => test_zci('Sum of natural numbers from 33 to 100 is 4,522.'),
    'sum 1-10' => test_zci('Sum of natural numbers from 1 to 10 is 55.'),
    'sum from 1 to 10' => test_zci('Sum of natural numbers from 1 to 10 is 55.'),
    '1-10 sum' => test_zci('Sum of natural numbers from 1 to 10 is 55.'),
    'add from 1 to 100' => test_zci('Sum of natural numbers from 1 to 100 is 5,050.'),

    # Invalid Input
    'sum 1 --- 10' => undef,
    'sum 100 - 10' => undef,
    'add ten to twenty' => undef,
);

done_testing;
