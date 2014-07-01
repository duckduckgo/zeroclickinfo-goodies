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
    'md5 digest this!' => test_zci('3838c8fb10a114e6d21203359ef147ad', html=>qr/.*/),
    'duckduckgo md5' => test_zci('96898bb8544fa56b03c08cdc09886c6c', html=>qr/.*/),
    'md5sum the sum of a string' => test_zci('a704c8833f9850cd342ead27207ca1a1', html=>qr/.*/),
);

done_testing;
