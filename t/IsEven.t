#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_even";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsEven )],
    "is 100 even" => test_zci("Yes"),
    "is 9999 even" => test_zci("No"),
    "is -500 even" => test_zci("Yes"),
    "is -4555 even" => test_zci("No"),
    "is 100000     even" => test_zci("Yes"),
    "is 10001    even" => test_zci("No"),
);

done_testing;
