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
    'md5 digest this!' => test_zci('Md5: 3838c8fb10a114e6d21203359ef147ad'),
    'md5 hex gimme the hex digest' => test_zci('Md5: 0ce78eeb15abe053207d79f9b8e5cbab'),
    'md5sum base64 gimme the digest encoded in base64' => test_zci('Md5: INa7hD+ZcscImFVGHvnuvQ'),
);

done_testing;
