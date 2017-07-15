#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'text_to_speech';
zci is_cached   => 1;

sub build_answer {
    return '',
    structured_answer => {
        data => {
            say => @_,
        },
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.text_to_speech.content',
            }
        }
    };
}

sub build_test { 
    test_zci(build_answer(@_))
}

ddg_goodie_test(
    [qw( DDG::Goodie::TextToSpeech )],
    'text to voice' => build_test(''),
    'text to speach' => build_test(''),
    'text to voice hello world' => build_test('hello world'),
    'text to speech 1 2 3' => build_test('1 2 3'),
);

done_testing;
