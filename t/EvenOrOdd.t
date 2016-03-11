#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "even_or_odd";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::EvenOrOdd )],
    "is 100 even or odd" => test_zci("Even"),
    "is 9999 even?" => test_zci("Odd"),
    "is -500 even" => test_zci("Even"),
    "-4555 even?" => test_zci("Odd"),
    "is 100000     even" => test_zci("Even"),
    "is 10001    even" => test_zci("Odd"),
);

done_testing;
