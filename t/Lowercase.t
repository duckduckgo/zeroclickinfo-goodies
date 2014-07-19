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
        test_zci('foo'),
    'lower case foO' =>
        test_zci('foo'),
    'lowercase john Doe' =>
        test_zci('john doe'),
    'lowercase GitHub' =>
        test_zci('github'),
    'lower case GitHub' =>
        test_zci('github'),
    'lc GitHub' =>
        test_zci('github'),
    'strtolower GitHub' =>
        test_zci('github'),
    'tolower GitHub' =>
        test_zci('github'),
);

done_testing;
