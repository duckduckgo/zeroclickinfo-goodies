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
    'md5 of password' => test_zci('5f4dcc3b5aa765d61d8327deb882cf99', html=>qr/.*/),
    'md5sum of "this"' => test_zci('9e925e9341b490bfd3b4c4ca3b0c1ef2', html=>qr/.*/),
    'md5 of "this' => test_zci('53d3e72f097a74f6d439fa88b91d5a71', html=>qr/.*/),
    'md5 hash' => test_zci('0800fc577294c34e0b28ad2839435945', html=>qr/.*/),
    'md5 hash         ' => test_zci('0800fc577294c34e0b28ad2839435945', html=>qr/.*/),
    'md5 hash of' => test_zci('8bf8854bebe108183caeb845c7676ae4', html=>qr/.*/),
    'md5 hash of  password ' => test_zci('5f4dcc3b5aa765d61d8327deb882cf99', html=>qr/.*/),
);

done_testing;
