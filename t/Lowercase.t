#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'lowercase';
zci is_cached => 1;

ddg_goodie_test(
    [
        'DDG::Goodie::Lowercase'
    ],
    'lowercase foo' =>
        test_zci('foo',
        html => qr/foo/),
    'lower case foO' =>
        test_zci('foo',
        html => qr/foo/),
    'lowercase john Doe' =>
        test_zci('john doe',
        html => qr/john doe/),
    'lowercase GitHub' =>
        test_zci('github',
        html => qr/github/),
    'lower case GitHub' =>
        test_zci('github',
        html => qr/github/),
    'lc GitHub' =>
        test_zci('github',
        html => qr/github/),
    'strtolower GitHub' =>
        test_zci('github',
        html => qr/github/),
    'tolower GitHub' =>
        test_zci('github',
        html => qr/github/),
    'how to lowercase text' => undef
);

done_testing;
