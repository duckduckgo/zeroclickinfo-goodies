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
        '10 px to em' => test_zci('There are 0.625 em in 10 px (assuming a 16px font size)'),
        '10 px to em' => test_zci(qr/0\.625/),
        '12.2 px in em assuming a 12.2px font size' => test_zci("There is 1 em in 12.2 px (assuming a 12.2px font size)"),
);

done_testing;
