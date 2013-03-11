#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'regexp';
zci is_cached => 1;

ddg_goodie_test(
        [qw( DDG::Goodie::Regexp )],
        'regexp /(hello)/ hello probably' => test_zci(
            "hello",
        ),
        'regexp /(dd)/ ddg' => test_zci(
            "dd",
        ),
);

done_testing;
