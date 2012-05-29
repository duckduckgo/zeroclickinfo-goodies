#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'ascii_conversion';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Ascii
        )],
        '01101010 to ascii' => test_zci('j'),
        '00111001 to ascii' => test_zci('9'),
        '01110100011010000110100101110011 in ascii' => test_zci('this'),
        '01110100011010000110000101110100 to ascii' => test_zci('that'),

);

done_testing;

