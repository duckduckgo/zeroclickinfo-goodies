#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'translation';
zci is_cached   => 1;

sub build_structured_answer {
    my ($expected_result, $expected_action, $expected_formatted_input) = @_;
    return $expected_result, structured_answer => {
        id   => 'pig_latin',
        name => 'Answer',
        data => {
            title    => "$expected_result",
            subtitle => "Translate $expected_action Pig Latin: $expected_formatted_input",
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
    'pig latin will this work?'       => build_test('illway isthay orkway?', 'to', 'will this work?'),
    'piglatin i love duckduckgo'      => build_test('iway ovelay uckduckgoday', 'to', 'i love duckduckgo'),
    'pig latin i love duckduckgo'     => build_test('iway ovelay uckduckgoday', 'to', 'i love duckduckgo'),
    'What is this? in piglatin'       => build_test('Atwhay isway isthay?', 'to', 'What is this?'),
    'in piglatin foo'                 => build_test('oofay', 'to', 'foo'),
    'from pigLatiN oofay'             => build_test('foo', 'from', 'oofay'),
    'piglatin in piglatin'            => build_test('iglatinpay', 'to', 'piglatin'),
    'iglatinpay from piglatin'        => build_test('piglatin', 'from', 'iglatinpay'),
    'pig latin'                       => undef,
    'piglatin'                        => undef,
    'what is piglatin?'               => undef,
    'from piglatin in piglatin'       => build_test('romfay iglatinpay', 'to', 'from piglatin'),
    'romfay iglatinpay from piglatin' => build_test('from piglatin', 'from', 'romfay iglatinpay'),
);

done_testing;
