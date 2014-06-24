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
    'md5 hex gimme the hex digest' => test_zci('0ce78eeb15abe053207d79f9b8e5cbab', html=>qr/.*/),
    'md5sum base64 gimme the digest encoded in base64' => test_zci('INa7hD+ZcscImFVGHvnuvQ', html=>qr/.*/),
);

done_testing;
