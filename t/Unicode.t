#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'unicode_conversion';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Unicode
        )],
        'U+263A' => test_zci("\x{263A} U+263A WHITE SMILING FACE, decimal: 9786, HTML: &#9786;, UTF-8: 0xE2 0x98 0xBA, block: Miscellaneous Symbols"),
);

done_testing;
