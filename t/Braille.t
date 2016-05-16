#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use Convert::Braille;
use utf8;

zci answer_type => 'braille';
zci is_cached   => 1;

sub build_structured_answer {
    my ($query, $response) = @_;
    return $response,
        structured_answer => {
            data => {
                title    => $response,
                subtitle => 'Braille translation: ' . $query,
            },
            templates => {
                group => 'text',
            }
        },
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Braille)],
    # Ascii/Unicode -> Braille
    'hello in braille'                => build_test('hello', '⠓⠑⠇⠇⠕'),
    'hello to braille'                => build_test('hello', '⠓⠑⠇⠇⠕'),
    'translate to braille to braille' => build_test('translate to braille', '⠞⠗⠁⠝⠎⠇⠁⠞⠑⠀⠞⠕⠀⠃⠗⠁⠊⠇⠇⠑'),
    'braille: asdf k'                 => build_test('asdf k', '⠁⠎⠙⠋⠀⠅'),
    # Braille -> Ascii/Unicode
    '⠓⠑⠀⠇⠇⠕'                       => build_test('&#x2813;&#x2811;&#x2800;&#x2807;&#x2807;&#x2815;', 'he llo'),
    '⠞⠗⠁⠝⠎⠇⠁⠞⠑⠀⠞⠕⠀⠃⠗⠁⠊⠇⠇⠑'   => build_test('&#x281E;&#x2817;&#x2801;&#x281D;&#x280E;&#x2807;&#x2801;&#x281E;&#x2811;&#x2800;&#x281E;&#x2815;&#x2800;&#x2803;&#x2817;&#x2801;&#x280A;&#x2807;&#x2807;&#x2811;', 'translate to braille'),
    '⠁⠎⠙⠋⠀⠅'                       => build_test('&#x2801;&#x280E;&#x2819;&#x280B;&#x2800;&#x2805;', 'asdf k'),
    # Invalid Queries
    'braille asdf k'                  => undef,
    'how long to learn braille'       => undef,
    'braille to braille is good'      => undef,
);

done_testing;