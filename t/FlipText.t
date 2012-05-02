#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'flip_text';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::FlipText
        )],
        'flip test' => test_zci("\x{0287}\x{0073}\x{01DD}\x{0287}"),
        'mirror test' => test_zci("\x{0287}\x{01DD}\x{0073}\x{0287}"),
);

done_testing;
