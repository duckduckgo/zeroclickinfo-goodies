#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'rafl';
zci is_cached => 0;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Rafl
        )],
        'rafl' => test_zci(qr/rafl is so everywhere, .+/),
);

done_testing;
