#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'kana';
zci is_cached => 1;

ddg_goodie_test(
    [
        'DDG::Goodie::Kana'
    ],
    'ahiru in hiragana' => test_zci('1',
        html => '<div><div class="zci__caption">Hiragana</div><div class="zci__content">あひる</div>',
    ),
    'ahiru in katakana' => test_zci('1',
        html => '<div><div class="zci__caption">Katakana</div><div class="zci__content">アヒル</div>',
    ),
    'アヒル to romaji' => test_zci('1',
        html => '<div><div class="zci__caption">Romaji</div><div class="zci__content">ahiru</div>',
    )
    'あひる in romaji' => test_zci('1',
        html => '<div><div class="zci__caption">Romaji</div><div class="zci__content">ahiru</div>',
    )
    '「みかん,りんご」 to romaji' => test_zci('1',
        html => '<div><div class="zci__caption">Romaji</div><div class="zci__content">\'mikan,ringo\'<div>',
    )
);

done_testing;
