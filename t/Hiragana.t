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

    "hiragana a" => test_zci('あ', html => "<div class='zci--hiragana text--primary'>あ</div>"),
    "hiragana konnichiwa"  => test_zci('こんにちわ', html => "<div class='zci--hiragana text--primary'>こんにちわ</div>"),
    "nihon hiragana" => test_zci('にほん', html => "<div class='zci--hiragana text--primary'>にほん</div>"),
    "hiragana tsukue no ue" => test_zci('つくえ の うえ', html => "<div class='zci--hiragana text--primary'>つくえ の うえ</div>"),
    "what is hiragana?" => undef,
    "hiragana" => undef,    
);

done_testing();