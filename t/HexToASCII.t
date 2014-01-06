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
        'ascii 0x7465007374'    => test_zci('test (ASCII)', html => 'te<code title="null">[NUL]</code>st (ASCII)'),
        'ascii 0x74657374' => test_zci('test (ASCII)', html => 'test (ASCII)'),
        'ascii 0x5468697320697320612074657374' => test_zci('This is a test (ASCII)', html => 'This is a test (ASCII)'),
);

done_testing;
