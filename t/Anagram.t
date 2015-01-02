#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'anagram';
zci is_cached   => 1;

ddg_goodie_test(
    [qw(DDG::Goodie::Anagram)],
    'Anagram filter' => test_zci(
        'trifle',
        structured_answer => {
            input     => ['filter'],
            operation => 'anagrams of',
            result    => 'trifle',
        }
    ),
    'anagrams events' => test_zci(
        'Steven',
        structured_answer => {
            input     => ['events'],
            operation => 'anagrams of',
            result    => 'Steven',
        }
    ),
    'anagram of algorithm' => test_zci(
        'logarithm',
        structured_answer => {
            input     => ['algorithm'],
            operation => 'anagrams of',
            result    => 'logarithm',
        }
    ),
    'anagrams of favorite' => test_zci(
        '-ANY-',
        structured_answer => {
            input     => ['favorite'],
            operation => 'scrambled letters of',
            result    => '-ANY-',
        }
    ),
    'anagrams of "Mixing it up"' => test_zci(
        '-ANY-',
        structured_answer => {
            input     => ['Mixing it up'],
            operation => 'scrambled letters of',
            result    => '-ANY-',
        }
    ),
    'anagram times' => test_zci(
        'emits, items, mites, smite',
        structured_answer => {
            input     => ['times'],
            operation => 'anagrams of',
            result    => 'emits, items, mites, smite',
        }
    ),
    'anagrams stop' => test_zci(
        'Post, opts, post, pots, spot, tops',
        structured_answer => {
            input     => ['stop'],
            operation => 'anagrams of',
            result    => 'Post, opts, post, pots, spot, tops',
        }
    ),
    'anagram of lost' => test_zci(
        'lots, slot',
        structured_answer => {
            input     => ['lost'],
            operation => 'anagrams of',
            result    => 'lots, slot',
        }
    ),
    'anagram of voldemort' => test_zci(
        'Tom Riddle',
        structured_answer => {
            input     => ['voldemort'],
            operation => 'anagrams of',
            result    => 'Tom Riddle',
        }
    ),
    # No result tests.
    'anagram of'              => undef,
    'anagrams for'            => undef,
    'anagrams for ""'         => undef,
    'anagrams for "867-5309"' => undef,
);

done_testing;
