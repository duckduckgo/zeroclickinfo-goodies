#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'md5';
zci is_cached => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::MD5
    )],
    'md5 digest this string' => test_zci('ad9b1db35500418a04eb2abe40e0ab7b'),
    'md5sum digest that string' => test_zci('0f814a4d82d8426b97d21815a2d463e3'),
);

done_testing;
