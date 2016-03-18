#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'anagram';
zci is_cached   => 1;

sub build_structured_answer {
    my ($word, $response) = @_;
    return $response,
        structured_answer => {
            id   => 'anagram',
            name => 'Answer',
            data => {
                title    => $response,
                subtitle => "Anagrams of $word",
            },
            templates => {
                group => 'text',
            },
        },
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw(DDG::Goodie::Anagram)],
    'Anagram filter'       => build_test('filter', 'trifle'),
    'anagrams events'      => build_test('events', 'Steven'),
    'anagram of algorithm' => build_test('algorithm', 'logarithm'),
    'anagram times'        => build_test('times', 'emits, items, mites, smite'),
    'anagrams stop'        => build_test('stop', 'Post, opts, post, pots, spot, tops'),
    'anagram of lost'      => build_test('lost', 'lots, slot'),
    'anagram of voldemort' => build_test('voldemort', 'Tom Riddle'),
    # Invalid Queries
    'anagram of'                 => undef,
    'Anagrams for'               => undef,
    'anagrams for ""'            => undef,
    'anagrams for "867-5309"'    => undef,
    'anagrams of favorite'       => undef,
    'anagrams of "Mixing it up"' => undef,
);

done_testing;
