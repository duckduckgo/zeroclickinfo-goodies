#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'caesar_cipher';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::CaesarCipher )],
    'caesar 2 abc' => test_zci(
        'cde',
        structured_answer => {
            input     => ['2', 'abc'],
            operation => 'Caesar cipher',
            result    => 'cde'
        },
    ),
    'caesar cipher -2 cde' => test_zci(
        'abc',
        structured_answer => {
            input     => ['-2', 'cde'],
            operation => 'Caesar cipher',
            result    => 'abc'
        },
    ),
    'caesar 52 abc' => test_zci(
        'abc',
        structured_answer => {
            input     => ['52', 'abc'],
            operation => 'Caesar cipher',
            result    => 'abc'
        },
    ),
    'caesar 1 TtEeSsTt!' => test_zci(
        'UuFfTtUu!',
        structured_answer => {
            input     => ['1', 'TtEeSsTt!'],
            operation => 'Caesar cipher',
            result    => 'UuFfTtUu!'
        },
    ),
    'caesar 0 test' => test_zci(
        'test',
        structured_answer => {
            input     => ['0', 'test'],
            operation => 'Caesar cipher',
            result    => 'test'
        },
    ),
    'caesar -26 test\\' => test_zci(
        'test\\',
        structured_answer => {
            input     => ['-26', 'test\\'],
            operation => 'Caesar cipher',
            result    => 'test\\'
        },
    ),
    'caesar 5 #test!{]17TEST#' => test_zci(
        '#yjxy!{]17YJXY#',
        structured_answer => {
            input     => ['5', '#test!{]17TEST#'],
            operation => 'Caesar cipher',
            result    => '#yjxy!{]17YJXY#'
        },
    ),
    'Caesar cipher 26 test text.' => test_zci(
        'test text.',
        structured_answer => {
            input     => ['26', 'test text.'],
            operation => 'Caesar cipher',
            result    => 'test text.'
        },
    ),
    'ceasar 13 "More Test Text"' => test_zci(
        '"Zber Grfg Grkg"',
        structured_answer => {
            input     => ['13', '"More Test Text"'],
            operation => 'Caesar cipher',
            result    => '&quot;Zber Grfg Grkg&quot;'
        },
    ),
    'caesar cipher hello' => undef,
);

done_testing;
