#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'chars';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Chars
        )],
        'chars test' => test_zci('4'),
        'chars this is a test' => test_zci('14'),
);

done_testing;
