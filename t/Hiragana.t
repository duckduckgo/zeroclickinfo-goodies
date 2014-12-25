#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

use utf8;

zci answer_type => 'hiragana';
zci is_cached => 1;

ddg_goodie_test(
  	[qw(
  		DDG::Goodie::Hiragana
  	)],

    "hiragana a" => test_zci('あ', html => "<div class='zci--hiragana text--primary'>&#x3042;</div>"),
    "hiragana konnichiwa"  => test_zci('こんにちわ', html => "<div class='zci--hiragana text--primary'>&#x3053;&#x3093;&#x306B;&#x3061;&#x308F;</div>"),
    "nihon hiragana" => test_zci('にほん', html => "<div class='zci--hiragana text--primary'>&#x306B;&#x307B;&#x3093;</div>"),
    "hiragana tsukue no ue" => test_zci('つくえ の うえ', html => "<div class='zci--hiragana text--primary'>&#x3064;&#x304F;&#x3048; &#x306E; &#x3046;&#x3048;</div>"),
    "Japanese zero" => undef,
    "what is hiragana?" => undef,
    "hiragana" => undef,    
);

done_testing();