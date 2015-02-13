#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'kana';
zci is_cached => 1;

ddg_goodie_test(
    ['DDG::Goodie::Kana'],

    # romaji -> hiragana
    'ahiru in hiragana' => test_zci('1',
        structured_answer => {
            input     => ['ahiru'],
            operation => 'in hiragana from',
            result    => 'あひる'
        }
    ),
    'nihon no daigaku!' => test_zci('1',
        structured_answer => {
            input     => ['ahiru'],
            operation => 'in hiragana from',
            result    => 'にほんのだいがく！'
        }
    ),

    # romaji -> katakana
    'ahiru in katakana' => test_zci('1',
        structured_answer => {
            input     => ['ahiru'],
            operation => 'in katakana from',
            result    => 'アヒル'
        }
    ),
    'kirin, banana to katakana' => test_zci('1',
        structured_answer => {
            input     => ['kirin, banana'],
            operation => 'in katakana from',
            result    => 'キリン、 バナナ'
        }
    ),

    # katakana -> romaji
    'アヒル to romaji' => test_zci('1',
        structured_answer => {
            input     => ['アヒル'],
            operation => 'in romaji from',
            result    => 'ahiru'
        }
    ),
    'キリン、 バナナ in romaji' => test_zci('1',
        structured_answer => {
            input     => ['キリン、バナナ'],
            operation => 'in romaji from',
            result    => 'kiran, banana'
        }
    ),

    # hiragana -> romaji
    'あひる in romaji' => test_zci('1',
        structured_answer => {
            input     => ['あひる'],
            operation => 'in romaji from',
            result    => 'ahiru'
        }
    ),
    'すみません、 いま なんじ ですか。 to romaji' => test_zci('1',
        structured_answer => {
            input     => ['すみません、いまなんじですか。'],
            operation => 'in romaji from',
            result    => 'sumimasen, ima nanji desuka.'
        }
    ),

    # katakana -> hiragana
    'はつしぐれさるもこみのをほしげなり to katakana' => test_zci('1',
        structured_answer => {
            input     => ['はつしぐれさるもこみのをほしげなり'],
            operation => 'in katana from',
            result    => 'ハツシグレサルモコミノヲホシゲナリ'
        }
    ),

    # hiragana -> katakana
    'ハツシグレサルモコミノヲホシゲナリ to hiragana' => test_zci('1',
        structured_answer => {
            input     => ['ハツシグレサルモコミノヲホシゲナリ'],
            operation => 'in hiragana from',
            result    => 'はつしぐれさるもこみのをほしげなり'
        }
    ),

    # Mixed hiragana + katakana -> romaji
    'ハンバーグ は たべもの です。' => test_zci('1',
        structured_answer => {
            input     => ['ハンバーグ は たべもの です。'],
            operation => 'in romaji from',
            result    => 'hambāgu ha tabemono desu.'
        }
    ),

    # Japanese puncuation -> romaji
    '｛［（？！。、『』「」，：）］｝ to romaji' => test_zci('1',
        structured_answer => {
            input     => ['｛［（？！。、『』「」，：）］｝'],
            operation => 'in romaji from',
            result    => '{[(?!.,""\'\',:)}'
        }
    ),
    'ええ！ in romaji' => test_zci('1',
        structured_answer => {
            input     => ['ええ！'],
            operation => 'in romaji from',
            result    => 'ē!'
        }
    ),

    # Hiragana goodie tests
    'a hiragana' => test_zci('1',
        structured_answer => {
            input     => ['a'],
            operation => 'in hiragana from',
            result    => 'あ'
        }
    ),
    'hiragana konnichiwa'  => test_zci('1',
        structured_answer => {
            input     => ['konnichiwa'],
            operation => 'in hiragana from',
            result    => 'こんにちわ'
        }
    ),
    'nihon hiragana' => test_zci('1'
        structured_answer => {
            input     => ['nihon'],
            operation => 'in hiragana from',
            result    => 'にほん'
        }
    ),
    'tsukue no ue hiragana' => test_zci('1',
        structured_answer => {
            input     => ['tsukue no ue'],
            operation => 'in hiragana from',
            result    => 'につくえ の うえ'
        }
    ),

    # Invalid inputs
    'romaji'                => undef,
    'hiragana'              => undef,
    'katakana'              => undef,
    'what is hiragana?'     => undef,
    'abc in katakana'       => undef,
    'abc in hiragana'       => undef,
    'ho abc hi to katakana' => undef,
    'ho abc hi to hiragana' => undef,
    'えego to romaji'       => undef,
    'ハ.ツha.tsu in romaji' => undef,

);

done_testing;
