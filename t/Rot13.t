#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'rot13';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Rot13
        )],
        'rot13 This is a test' => test_zci('ROT13: Guvf vf n grfg'),
        'rot13 thirteen' => test_zci('ROT13: guvegrra'),
        'rot13 guvegrra' => test_zci('ROT13: thirteen'),
);

done_testing;
