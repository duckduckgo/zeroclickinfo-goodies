#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'conversion';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::EmToPx
        )],
        '10 px to em' => test_zci('0.625 em in 10 px'),
        '10 px to em' => test_zci(qr/0\.625/),
);

done_testing;
