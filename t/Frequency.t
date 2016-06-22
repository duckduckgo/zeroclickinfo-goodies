#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci is_cached => 1;
zci answer_type => 'frequency';

my $general_title_prefix = "Frequency of each character in";

sub build_structured_test {
    my ($plaintext, $title, $record_data, $record_keys) = @_;

    return $plaintext,
    structured_answer => {
        data => {
        title => $title,
        record_data => $record_data,
        record_keys => $record_keys
        },
        templates => {
            group => "list",
            options => {
                content => "record"
            }
        }
    };
}

sub build_test {
    test_zci(build_structured_test(@_));
}

ddg_goodie_test(
        [qw(
                DDG::Goodie::Frequency
        )],

    "frequency of all in test" => build_test('e:1/4 s:1/4 t:2/4', "$general_title_prefix test", {
        'e' => 1,
        's' => 1,
        't' => 2
    }, ['e', 's', 't']),

    'frequency of all letters in test' => build_test('e:1/4 s:1/4 t:2/4', "$general_title_prefix test", {
        'e' => 1,
        's' => 1,
        't' => 2
    }, ['e', 's', 't']),

    'frequency of letters in test' => build_test('e:1/4 s:1/4 t:2/4', "$general_title_prefix test", {
        'e' => 1,
        's' => 1,
        't' => 2
    }, ['e', 's', 't']),

    'frequency of all characters in test' => build_test('e:1/4 s:1/4 t:2/4', "$general_title_prefix test", {
        'e' => 1,
        's' => 1,
        't' => 2
    }, ['e', 's', 't']),

    'frequency of all chars in test' => build_test('e:1/4 s:1/4 t:2/4', "$general_title_prefix test", {
        'e' => 1,
        's' => 1,
        't' => 2
    }, ['e', 's', 't']),

    'frequency of all in testing 1234 ABC!' => build_test('a:1/10 b:1/10 c:1/10 e:1/10 g:1/10 i:1/10 n:1/10 s:1/10 t:2/10', "$general_title_prefix testing 1234 ABC!", {
        'a' => 1,
        'b' => 1,
        'c' => 1,
        'e' => 1,
        'g' => 1,
        'i' => 1,
        'n' => 1,
        's' => 1,
        't' => 2
    }, ['a', 'b', 'c', 'e', 'g', 'i', 'n', 's', 't']),

    'frequency of a in Atlantic Ocean' => build_test('a:3/13', "Frequency of a in Atlantic Ocean", {
        "a" => 3
    }, ["a"]),

    'freq of B in battle' => build_test('b:1/6', "Frequency of B in battle", {
        'b' => 1
    }, ['b']),

    'freq of s in Spoons' => build_test('s:2/6', "Frequency of s in Spoons", {
        's' => 2
    }, ['s']),

    'frequency s in spoons' => undef,
    'freq s in spoons' => undef,
    'frequency s spoons' => undef,
    'freq s spoons' => undef,
    'frequency of s spoons' => undef,
    'freq of s spoons' => undef

);

done_testing;
