#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'translation';
zci is_cached   => 1;

sub build_structured_answer {
    my ($expected_result, $expected_formatted_input) = @_;
    return $expected_result, structured_answer => {
        id   => 'pig_latin',
        name => 'Answer',
        data => {
            title    => "$expected_result",
            subtitle => "Translate to Pig Latin: $expected_formatted_input",
        },
        templates => {
            group  => 'text',
            moreAt => 0,
        },
    };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::PigLatin )],
    'pig latin will this work?'   => build_test('illway isthay orkway?', 'will this work?'),
    'piglatin i love duckduckgo'  => build_test('iway ovelay uckduckgoday', 'i love duckduckgo'),
    'pig latin i love duckduckgo' => build_test('iway ovelay uckduckgoday', 'i love duckduckgo'),
    'pig latin'                   => undef,
    'piglatin'                    => undef,
);

done_testing;
