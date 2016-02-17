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
    # Basic forms
    'in pig latin i love duckduckgo' => build_test('iway ovelay uckduckgoday', 'to', 'i love duckduckgo'),
    'in piglatin foo'                => build_test('oofay', 'to', 'foo'),
    'from pigLatiN oofay'            => build_test('foo', 'from', 'oofay'),
    'piglatin in piglatin'           => build_test('iglatinpay', 'to', 'piglatin'),
    'iglatinpay from piglatin'       => build_test('piglatin', 'from', 'iglatinpay'),
    # Additional forms
    'from piglatin in piglatin'                 => build_test('romfay iglatinpay', 'to', 'from piglatin'),
    'romfay iglatinpay from piglatin'           => build_test('from piglatin', 'from', 'romfay iglatinpay'),
    'how do you say I am awesome in piglatin?'  => build_test('Iway amway awesomeway', 'to', 'I am awesome'),
    'what is piglatin in piglatin?'             => build_test('iglatinpay', 'to', 'piglatin'),
    'translate hello to piglatin.'              => build_test('ellohay', 'to', 'hello'),
    'translate ellohay from piglatin'           => build_test('hello', 'from', 'ellohay'),
    'How would I say What is this? in piglatin' => build_test('Atwhay isway isthay?', 'to', 'What is this?'),
    'What is piglatin to piglatin'              => build_test('Atwhay isway iglatinpay', 'to', 'What is piglatin'),
    'translate foo in piglatin'                 => build_test('ranslatetay oofay', 'to', 'translate foo'),
    'translate to piglatin'                     => build_test('ranslatetay', 'to', 'translate'),
    'what is in piglatin'                       => build_test('atwhay isway', 'to', 'what is'),
    # Non-matchers
    'piglatin i love duckduckgo' => undef,
    'pig latin will this work?'  => undef,
    'pig latin'                  => undef,
    'piglatin'                   => undef,
    'what is piglatin?'          => undef,
    'what is in piglatin?'       => undef,
    'piglatin 0'                 => undef,
);

done_testing;
