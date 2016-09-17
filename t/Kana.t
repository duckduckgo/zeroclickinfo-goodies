#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'kana';
zci is_cached => 1;

sub build_test {
    my ($text, $title, $script, $subtitle) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => $title,
            subtitle => "Convert to $script: $subtitle",
        },
        templates => {
            group => 'text'
        }
    });
}


ddg_goodie_test(
    ['DDG::Goodie::Kana'],

    # romaji -> hiragana
    'ahiru in hiragana' => build_test('ahiru converted to hiragana is あひる','あひる', "Hiragana", 'ahiru'),
    'nihon no daigaku! to hiragana' => build_test('nihon no daigaku! converted to hiragana is にほん の だいがく！', 'にほん の だいがく！', 'Hiragana', 'nihon no daigaku!'),
    # romaji -> katakana
    'ahiru in katakana' => build_test('ahiru converted to katakana is アヒル', 'アヒル', "Katakana", "ahiru",),
    'kirin, banana to katakana' => build_test('kirin, banana converted to katakana is キリン、 バナナ','キリン、 バナナ', "Katakana", 'kirin, banana'),

    # katakana -> romaji
    'アヒル to romaji' => build_test('アヒル converted to romaji is ahiru', 'ahiru', 'Romaji', 'アヒル'),
    'キリン、 バナナ in romaji' => build_test('キリン、 バナナ converted to romaji is kirin, banana', 'kirin, banana', "Romaji", 'キリン、 バナナ'),

    # hiragana -> romaji
    'あひる in romaji' => build_test('あひる converted to romaji is ahiru', "ahiru", "Romaji", 'あひる'),
    'すみません、 いま なんじ ですか。 to romaji' => build_test('すみません、 いま なんじ ですか。 converted to romaji is sumimasen, ima nanji desuka.', 'sumimasen, ima nanji desuka.', "Romaji", 'すみません、 いま なんじ ですか。'),

    # hiragana -> katakana
    'はつしぐれさるもこみのをほしげなり to katakana' => build_test('はつしぐれさるもこみのをほしげなり converted to katakana is ハツシグレサルモコミノヲホシゲナリ', 'ハツシグレサルモコミノヲホシゲナリ', "Katakana", 'はつしぐれさるもこみのをほしげなり'),

    # katakana -> hirgana
    'ハツシグレサルモコミノヲホシゲナリ to hiragana' => build_test('ハツシグレサルモコミノヲホシゲナリ converted to hiragana is はつしぐれさるもこみのをほしげなり', 'はつしぐれさるもこみのをほしげなり', "Hiragana", 'ハツシグレサルモコミノヲホシゲナリ'),

    # kana -> romaji
    'ハンバーガーはたべものです。 to romaji' => build_test('ハンバーガーはたべものです。 converted to romaji is hambāgāhatabemonodesu.', 'hambāgāhatabemonodesu.', 'Romaji', 'ハンバーガーはたべものです。'),

    # japanese puncuation -> romaji
    '｛［（？！。、『』あ「」，：）］｝ to romaji' => build_test('｛［（？！。、『』あ「」，：）］｝ converted to romaji is {[(?!.,""a\'\',:)]}', '{[(?!.,""a\'\',:)]}', 'Romaji', '｛［（？！。、『』あ「」，：）］｝'),
    'ええ！ in romaji' => build_test('ええ！ converted to romaji is ē!', 'ē!', 'Romaji', 'ええ！'),

    # Hiragana goodie tests
    'a hiragana' => build_test('a converted to hiragana is あ',  'あ', 'Hiragana', 'a'),
    'konnichiwa hiragana' => build_test('konnichiwa converted to hiragana is こんにちわ', 'こんにちわ', 'Hiragana', 'konnichiwa'),
    'nihon hiragana' => build_test('nihon converted to hiragana is にほん', 'にほん', 'Hiragana', 'nihon'),
    'tsukue no ue hiragana' => build_test('tsukue no ue converted to hiragana is つくえ の うえ', 'つくえ の うえ', 'Hiragana', 'tsukue no ue'),

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
