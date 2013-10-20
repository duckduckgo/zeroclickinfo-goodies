#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'hexadecimal conversion';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
DDG::Goodie::HexToDec
)],
        'hextodec ff' => test_zci("Decimal Value: 255"),
        "hextodec f1" => test_zci("Decimal Value: 241"),
        "hextodec a" => test_zci("Decimal Value: 10"),
);

done_testing;