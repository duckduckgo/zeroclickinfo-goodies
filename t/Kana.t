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
        structured_answer => {
            input     => ['ahiru'],
            operation => 'in hiragana from',
            result    => 'あひる'
        }
    ),
    'ahiru in katakana' => test_zci('1',
        structured_answer => {
            input     => ['ahiru'],
            operation => 'in katakana from',
            result    => "アヒル"
        }
    ),
    'アヒル to romaji' => test_zci('1',
        structured_answer => {
            input     => ['アヒル'],
            operation => 'in romaji from',
            result    => 'ahiru'
        }
    ),
    'あひる in romaji' => test_zci('1',
        structured_answer => {
            input     => ['あひる'],
            operation => 'in romaji from',
            result    => 'ahiru'
        }
    ),
    '「みかん,りんご」 to romaji' => test_zci('1',
        structured_answer => {
            input     => ['「みかん,りんご」'],
            operation => 'in romaji from',
            result    => '\'mikan,ringo\''
        }
    ),
);

done_testing;
