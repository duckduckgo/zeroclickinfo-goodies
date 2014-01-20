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
    'sum 1 to 10' => test_zci('Sum: 55'),
    'sum 55 to 63' => test_zci('Sum: 531'),
    'add 33 to 100' => test_zci('Sum: 4522'),
);

done_testing;
