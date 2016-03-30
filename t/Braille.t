#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Convert::Braille;
use utf8;

zci answer_type => 'braille';
zci is_cached   => 1;

sub build_structured_answer {
    my ($query, $response, $type) = @_;
    return $response,
        structured_answer => {
            data => {
                title    => $response,
                subtitle => 'Translate "' . $query . '" to ' . $type,
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
    'hello in braille'                => build_test('hello', '⠓⠑⠇⠇⠕', 'Braille'),
    'hello to braille'                => build_test('hello', '⠓⠑⠇⠇⠕', 'Braille'),
    'translate to braille to braille' => build_test('translate to braille', '⠞⠗⠁⠝⠎⠇⠁⠞⠑⠀⠞⠕⠀⠃⠗⠁⠊⠇⠇⠑', 'Braille'),
    'braille: asdf k'                 => build_test('asdf k', '⠁⠎⠙⠋⠀⠅', 'Braille'),
    # Braille -> Ascii/Unicode
    '⠓⠑⠀⠇⠇⠕'                       => build_test('⠓⠑⠀⠇⠇⠕', 'he llo', 'Ascii/Unicode'),
    '⠞⠗⠁⠝⠎⠇⠁⠞⠑⠀⠞⠕⠀⠃⠗⠁⠊⠇⠇⠑'  => build_test('⠞⠗⠁⠝⠎⠇⠁⠞⠑⠀⠞⠕⠀⠃⠗⠁⠊⠇⠇⠑', 'translate to braille', 'Ascii/Unicode'),
    '⠁⠎⠙⠋⠀⠅'                       => build_test('⠁⠎⠙⠋⠀⠅', 'asdf k', 'Ascii/Unicode'),
    # Invalid Queries
    'braille asdf k'                  => undef,
    'how long to learn braille'       => undef,
    'braille to braille is good'      => undef,
);

done_testing;
