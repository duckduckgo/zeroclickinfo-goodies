#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'roman_numeral_conversion';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Roman
        )],
        'roman 155' => test_zci('CLV (roman numeral conversion)'),
);

done_testing;
