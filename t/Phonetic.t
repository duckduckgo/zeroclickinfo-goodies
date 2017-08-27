#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'phonetic';
zci is_cached => 1;

sub build_answer {
    my($word, $answer) = @_;
    return "Phonetic: " . $answer,
        structured_answer => {
            data => {
                title => $answer,
                subtitle => "Phonetic: " . $word,
            },
            templates => {
                group => 'text',
            }
        };
}

sub build_test { test_zci(build_answer(@_)) }

ddg_goodie_test(
        [qw(
                DDG::Goodie::Phonetic
        )],
        'phonetic what duck' => build_test('what duck', 'Whiskey-Hotel-Alfa-Tango Delta-Uniform-Charlie-Kilo'),
        'phonetic through yonder' => build_test('through yonder', 'Tango-Hotel-Romeo-Oscar-Uniform-Golf-Hotel Yankee-Oscar-November-Delta-Echo-Romeo'),
        'phonetic window quacks' => build_test('window quacks', 'Whiskey-India-November-Delta-Oscar-Whiskey Quebec-Uniform-Alfa-Charlie-Kilo-Sierra'),
        'phonetic Who are you?' => build_test('who are you?', 'Whiskey-Hotel-Oscar Alfa-Romeo-Echo Yankee-Oscar-Uniform'),
        'what is phonetic?' => undef,
);

done_testing;
