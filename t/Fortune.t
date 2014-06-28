#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'fortune';
zci is_cached => 0;

ddg_goodie_test(
    [qw(
        DDG::Goodie::Fortune
    )],
    'gimmie a fortune cookie' => test_zci(qr/.+/),
    'gimmie a unix fortune' => test_zci(qr/.+/),
    'give me a fortune cookie!' => test_zci(qr/.+/),
    'give me a unix fortune!' => test_zci(qr/.+/),
    'unix fortune cookie' => test_zci(qr/.+/),
);

done_testing;

