#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'hiragana';
zci is_cached => 1;

ddg_goodie_test(
  	[qw(
  		DDG::Goodie::Hiragana
  	)],

    "hiragana a" => test_zci('あ'),
    "hiragana konnichiwa"  => test_zci('こんにちわ'),
    "what is hiragana?" => undef,
    "hiragana" => undef,
    
);

done_testing();