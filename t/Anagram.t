#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'anagram';
zci is_cached   => 1;

ddg_goodie_test(
    [qw(DDG::Goodie::Anagram)],
    # Sucessful anagram tests.
    'Anagrams for filter'          => test_zci('trifle',                             html => qr/Anagrams of "filter"/),
    'anagram filter'               => test_zci('trifle',                             html => qr/Anagrams of "filter"/),
    'anagrams of events'           => test_zci('Steven',                             html => qr/Anagrams of "events"/),
    'anagram of algorithm'         => test_zci('logarithm',                          html => qr/Anagrams of "algorithm"/),
    'show anagram of algorithm'    => test_zci('logarithm',                          html => qr/Anagrams of "algorithm"/),
    'anagrams for times'           => test_zci('emits, items, mites, smite',         html => qr/Anagrams of "times"/),
    'show anagrams of stop'        => test_zci('Post, opts, post, pots, spot, tops', html => qr/Anagrams of "stop"/),
    'find anagram for stop'        => test_zci('Post, opts, post, pots, spot, tops', html => qr/Anagrams of "stop"/),
    'anagrams lost'                => test_zci('lots, slot',                         html => qr/Anagrams of "lost"/),
    'anagrams of lost'             => test_zci('lots, slot',                         html => qr/Anagrams of "lost"/),
    'anagram for lost'             => test_zci('lots, slot',                         html => qr/Anagrams of "lost"/),
    'anagram of lost'              => test_zci('lots, slot',                         html => qr/Anagrams of "lost"/),
    'anagram of filter'            => test_zci('trifle',                             html => qr/Anagrams of "filter"/),
    'anagram of Filter'            => test_zci('trifle',                             html => qr/Anagrams of "Filter"/),
    'anagram of "partial men"'     => test_zci('Parliament, parliament',             html => qr/Anagrams of "partial men"/),
    'find anagram for partial men' => test_zci('Parliament, parliament',             html => qr/Anagrams of "partial men"/),
    # Uncached scrambles tests.
    'anagrams of favorite' => test_zci(
        'favorite',
        html      => qr/we found no anagrams for "favorite".*scrambled it for you:/,
        is_cached => 0
    ),
    'anagram for "Mixing it up"' => test_zci(
        'Mixing it up',
        html      => qr/we found no anagrams for "Mixing it up".*scrambled it for you:/,
        is_cached => 0
    ),
    # Full HTML test.
    'anagrams of slot' => test_zci(
        'lost, lots',
        html =>
          "<div class='zci--anagrams'><span class='text--secondary'>Anagrams of \"slot\"</span><br/><span class='text--primary'>lost, lots</span></div>",
    ),
    # No result tests.
    'anagram of'              => undef,
    'anagrams for'            => undef,
    'anagrams for ""'         => undef,
    'anagrams for "867-5309"' => undef,
);

done_testing;
