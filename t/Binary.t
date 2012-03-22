#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'binary_conversion';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Binary
        )],
        'this in binary' => test_zci('01110100011010000110100101110011'),
        'that to binary' => test_zci('01110100011010000110000101110100'),
);

done_testing;
