#! /usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'rand';
zci is_cached => 0;

ddg_goodie_test(
    [
        'DDG::Goodie::RandomName'
    ],
    'random Name' => test_zci (qr/\w\w \(random\)/),
    'random name' => test_zci (qr/\w\w \(random\)/),
);

done_testing;
