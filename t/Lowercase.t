#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

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
);

done_testing;
