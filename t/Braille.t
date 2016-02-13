#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Convert::Braille;
use utf8;

zci answer_type => 'braille';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Braille)],
    'hello in braille' => test_zci(
        "⠓⠑⠇⠇⠕ (Braille)",
        structured_answer => {
            input     => ['hello'],
            operation => 'Braille translation',
            result    => '&#x2813;&#x2811;&#x2807;&#x2807;&#x2815;'
        }
    ),
    '⠓⠑⠇⠇⠕' => test_zci(
        "hello (Braille)",
        structured_answer => {
            input     => ['&#x2813;&#x2811;&#x2807;&#x2807;&#x2815;'],
            operation => 'Braille translation',
            result    => 'hello'
        }
    ),
    'translate to braille translate to braille' => test_zci(
        "⠞⠗⠁⠝⠎⠇⠁⠞⠑⠀⠞⠕⠀⠃⠗⠁⠊⠇⠇⠑ (Braille)",
        structured_answer => {
            input     => ['translate to braille'],
            operation => 'Braille translation',
            result =>
              '&#x281E;&#x2817;&#x2801;&#x281D;&#x280E;&#x2807;&#x2801;&#x281E;&#x2811;&#x2800;&#x281E;&#x2815;&#x2800;&#x2803;&#x2817;&#x2801;&#x280A;&#x2807;&#x2807;&#x2811;'
        }
    ),
    '⠞⠗⠁⠝⠎⠇⠁⠞⠑⠀⠞⠕⠀⠃⠗⠁⠊⠇⠇⠑' => test_zci(
        "translate to braille (Braille)",
        structured_answer => {
            input => [
                '&#x281E;&#x2817;&#x2801;&#x281D;&#x280E;&#x2807;&#x2801;&#x281E;&#x2811;&#x2800;&#x281E;&#x2815;&#x2800;&#x2803;&#x2817;&#x2801;&#x280A;&#x2807;&#x2807;&#x2811;'
            ],
            operation => 'Braille translation',
            result    => 'translate to braille'
          }

    ),
    'braille asdf k' => test_zci(
        "⠁⠎⠙⠋⠀⠅ (Braille)",
        structured_answer => {
            input     => ['asdf k'],
            operation => 'Braille translation',
            result    => '&#x2801;&#x280E;&#x2819;&#x280B;&#x2800;&#x2805;'
          }

    ),
    '⠁⠎⠙⠋⠀⠅' => test_zci(
        "asdf k (Braille)",
        structured_answer => {
            input     => ['&#x2801;&#x280E;&#x2819;&#x280B;&#x2800;&#x2805;'],
            operation => 'Braille translation',
            result    => 'asdf k'
          }

    ),
);

done_testing;
