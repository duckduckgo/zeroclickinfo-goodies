#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'epoch';
zci is_cached => 1;

ddg_goodie_test(
        [qw( DDG::Goodie::Epoch )],
        'epoch' => test_zci(
            qr/Unix time/,
        ),
);

done_testing;

