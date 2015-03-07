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
            operation => 'Convert to Hiragana',
            result    => 'あひる'
        }
    ),
    'nihon no daigaku! to hiragana' => test_zci(
        'nihon no daigaku! converted to hiragana is にほん の だいがく！',
        structured_answer => {
            input     => ['nihon no daigaku!'],
            operation => 'Convert to Hiragana',
            result    => 'にほん の だいがく！'
        }
    ),

    # romaji -> katakana
    'ahiru in katakana' => test_zci(
        'ahiru converted to katakana is アヒル',
        structured_answer => {
            input     => ['ahiru'],
            operation => 'Convert to Katakana',
            result    => 'アヒル'
        }
    ),
    'kirin, banana to katakana' => test_zci(
        'kirin, banana converted to katakana is キリン、 バナナ',
        structured_answer => {
            input     => ['kirin, banana'],
            operation => 'Convert to Katakana',
            result    => 'キリン、 バナナ'
        }
    ),

    # katakana -> romaji
    'アヒル to romaji' => test_zci(
        'アヒル converted to romaji is ahiru',
        structured_answer => {
            input     => ['アヒル'],
            operation => 'Convert to Romaji',
            result    => 'ahiru'
        }
    ),
    'キリン、 バナナ in romaji' => test_zci(
        'キリン、 バナナ converted to romaji is kirin, banana',
        structured_answer => {
            input     => ['キリン、 バナナ'],
            operation => 'Convert to Romaji',
            result    => 'kirin, banana'
        }
    ),

    # hiragana -> romaji
    'あひる in romaji' => test_zci(
        'あひる converted to romaji is ahiru',
        structured_answer => {
            input     => ['あひる'],
            operation => 'Convert to Romaji',
            result    => 'ahiru'
        }
    ),
    'すみません、 いま なんじ ですか。 to romaji' => test_zci(
        'すみません、 いま なんじ ですか。 converted to romaji is sumimasen, ima nanji desuka.',
        structured_answer => {
            input     => ['すみません、 いま なんじ ですか。'],
            operation => 'Convert to Romaji',
            result    => 'sumimasen, ima nanji desuka.'
        }
    ),

    # hiragana -> katakana
    'はつしぐれさるもこみのをほしげなり to katakana' => test_zci(
        'はつしぐれさるもこみのをほしげなり converted to katakana is ハツシグレサルモコミノヲホシゲナリ',
        structured_answer => {
            input     => ['はつしぐれさるもこみのをほしげなり'],
            operation => 'Convert to Katakana',
            result    => 'ハツシグレサルモコミノヲホシゲナリ'
        }
    ),

    # katakana -> hirgana
    'ハツシグレサルモコミノヲホシゲナリ to hiragana' => test_zci(
        'ハツシグレサルモコミノヲホシゲナリ converted to hiragana is はつしぐれさるもこみのをほしげなり',
        structured_answer => {
            input     => ['ハツシグレサルモコミノヲホシゲナリ'],
            operation => 'Convert to Hiragana',
            result    => 'はつしぐれさるもこみのをほしげなり'
        }
    ),

    # kana -> romaji
    'ハンバーガーはたべものです。 to romaji' => test_zci(
        'ハンバーガーはたべものです。 converted to romaji is hambāgāhatabemonodesu.',
        structured_answer => {
            input     => ['ハンバーガーはたべものです。'],
            operation => 'Convert to Romaji',
            result    => 'hambāgāhatabemonodesu.'
        }
    ),

    # japanese puncuation -> romaji
    '｛［（？！。、『』あ「」，：）］｝ to romaji' => test_zci(
        '｛［（？！。、『』あ「」，：）］｝ converted to romaji is {[(?!.,""a\'\',:)]}',
        structured_answer => {
            input     => ['｛［（？！。、『』あ「」，：）］｝'],
            operation => 'Convert to Romaji',
            result    => '{[(?!.,""a\'\',:)]}'
        }
    ),
    'ええ！ in romaji' => test_zci(
        'ええ！ converted to romaji is ē!',
        structured_answer => {
            input     => ['ええ！'],
            operation => 'Convert to Romaji',
            result    => 'ē!'
        }
    ),

    # Hiragana goodie tests
    'a hiragana' => test_zci(
        'a converted to hiragana is あ',
        structured_answer => {
            input     => ['a'],
            operation => 'Convert to Hiragana',
            result    => 'あ'
        }
    ),
    'konnichiwa hiragana' => test_zci(
        'konnichiwa converted to hiragana is こんにちわ',
        structured_answer => {
            input     => ['konnichiwa'],
            operation => 'Convert to Hiragana',
            result    => 'こんにちわ'
        }
    ),
    'nihon hiragana' => test_zci(
        'nihon converted to hiragana is にほん',
        structured_answer => {
            input     => ['nihon'],
            operation => 'Convert to Hiragana',
            result    => 'にほん'
        }
    ),
    'tsukue no ue hiragana' => test_zci(
        'tsukue no ue converted to hiragana is つくえ の うえ',
        structured_answer => {
            input     => ['tsukue no ue'],
            operation => 'Convert to Hiragana',
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
