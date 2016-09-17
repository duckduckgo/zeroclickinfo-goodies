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
    '⠓⠑⠀⠇⠇⠕'                       => build_test('⠓⠑⠀⠇⠇⠕', 'he llo'),
    '⠞⠗⠁⠝⠎⠇⠁⠞⠑⠀⠞⠕⠀⠃⠗⠁⠊⠇⠇⠑'   => build_test('⠞⠗⠁⠝⠎⠇⠁⠞⠑⠀⠞⠕⠀⠃⠗⠁⠊⠇⠇⠑', 'translate to braille'),
    '⠁⠎⠙⠋⠀⠅'                       => build_test('⠁⠎⠙⠋⠀⠅', 'asdf k'),
    # Invalid Queries
    'braille asdf k'                  => undef,
    'how long to learn braille'       => undef,
    'braille to braille is good'      => undef,
);

done_testing;
