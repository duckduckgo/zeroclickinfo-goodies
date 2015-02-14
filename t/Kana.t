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
    'ahiru in hiragana' => test_zci(
        'ahiru converted to hiragana is あひる',
        structured_answer => {
            input     => ['ahiru'],
            operation => 'in hiragana from',
            result    => 'あひる'
        }
    ),
    'nihon no daigaku! to hiragana' => test_zci(
        'nihon no daigaku! converted to hiragana is にほん の だいがく！',
        structured_answer => {
            input     => ['nihon no daigaku!'],
            operation => 'in hiragana from',
            result    => 'にほん の だいがく！'
        }
    ),

    # romaji -> katakana
    'ahiru in katakana' => test_zci(
        'ahiru converted to katakana is アヒル',
        structured_answer => {
            input     => ['ahiru'],
            operation => 'in katakana from',
            result    => 'アヒル'
        }
    ),
    'kirin, banana to katakana' => test_zci(
        'kirin, banana converted to katakana is キリン、 バナナ',
        structured_answer => {
            input     => ['kirin, banana'],
            operation => 'in katakana from',
            result    => 'キリン、 バナナ'
        }
    ),

    # katakana -> romaji
    'アヒル to romaji' => test_zci(
        'アヒル converted to romaji is ahiru',
        structured_answer => {
            input     => ['アヒル'],
            operation => 'in romaji from',
            result    => 'ahiru'
        }
    ),
    'キリン、 バナナ in romaji' => test_zci(
        'キリン、 バナナ converted to romaji is kirin, banana',
        structured_answer => {
            input     => ['キリン、 バナナ'],
            operation => 'in romaji from',
            result    => 'kirin, banana'
        }
    ),

    # hiragana -> romaji
    'あひる in romaji' => test_zci(
        'あひる converted to romaji is ahiru',
        structured_answer => {
            input     => ['あひる'],
            operation => 'in romaji from',
            result    => 'ahiru'
        }
    ),
    'すみません、 いま なんじ ですか。 to romaji' => test_zci(
        'すみません、 いま なんじ ですか。 converted to romaji is sumimasen, ima nanji desuka.',
        structured_answer => {
            input     => ['すみません、 いま なんじ ですか。'],
            operation => 'in romaji from',
            result    => 'sumimasen, ima nanji desuka.'
        }
    ),

    # hiragana -> katakana
    'はつしぐれさるもこみのをほしげなり to katakana' => test_zci(
        'はつしぐれさるもこみのをほしげなり converted to katakana is ハツシグレサルモコミノヲホシゲナリ',
        structured_answer => {
            input     => ['はつしぐれさるもこみのをほしげなり'],
            operation => 'in katakana from',
            result    => 'ハツシグレサルモコミノヲホシゲナリ'
        }
    ),

    # katakana -> hirgana
    'ハツシグレサルモコミノヲホシゲナリ to hiragana' => test_zci(
        'ハツシグレサルモコミノヲホシゲナリ converted to hiragana is はつしぐれさるもこみのをほしげなり',
        structured_answer => {
            input     => ['ハツシグレサルモコミノヲホシゲナリ'],
            operation => 'in hiragana from',
            result    => 'はつしぐれさるもこみのをほしげなり'
        }
    ),

    # kana -> romaji
    'ハンバーガーはたべものです。 to romaji' => test_zci(
        'ハンバーガーはたべものです。 converted to romaji is hambāgāhatabemonodesu.',
        structured_answer => {
            input     => ['ハンバーガーはたべものです。'],
            operation => 'in romaji from',
            result    => 'hambāgāhatabemonodesu.'
        }
    ),

    # japanese puncuation -> romaji
    '｛［（？！。、『』あ「」，：）］｝ to romaji' => test_zci(
        '｛［（？！。、『』あ「」，：）］｝ converted to romaji is {[(?!.,""a\'\',:)]}',
        structured_answer => {
            input     => ['｛［（？！。、『』あ「」，：）］｝'],
            operation => 'in romaji from',
            result    => '{[(?!.,""a\'\',:)]}'
        }
    ),
    'ええ！ in romaji' => test_zci(
        'ええ！ converted to romaji is ē!',
        structured_answer => {
            input     => ['ええ！'],
            operation => 'in romaji from',
            result    => 'ē!'
        }
    ),

    # Hiragana goodie tests
    'a hiragana' => test_zci(
        'a converted to hiragana is あ',
        structured_answer => {
            input     => ['a'],
            operation => 'in hiragana from',
            result    => 'あ'
        }
    ),
    'konnichiwa hiragana' => test_zci(
        'konnichiwa converted to hiragana is こんにちわ',
        structured_answer => {
            input     => ['konnichiwa'],
            operation => 'in hiragana from',
            result    => 'こんにちわ'
        }
    ),
    'nihon hiragana' => test_zci(
        'nihon converted to hiragana is にほん',
        structured_answer => {
            input     => ['nihon'],
            operation => 'in hiragana from',
            result    => 'にほん'
        }
    ),
    'tsukue no ue hiragana' => test_zci(
        'tsukue no ue converted to hiragana is つくえ の うえ',
        structured_answer => {
            input     => ['tsukue no ue'],
            operation => 'in hiragana from',
            result    => 'つくえ の うえ'
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
