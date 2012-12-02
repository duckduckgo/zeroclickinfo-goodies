#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'ascii';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::HexToASCII
        )],
        'ascii 0x74657374' => test_zci('ASCII: test'),
        'ascii 0x5468697320697320612074657374' => test_zci('ASCII: This is a test'),
);

done_testing;
