#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'anagram';
zci is_cached => 0;

ddg_goodie_test(
    [qw(DDG::Goodie::Anagram)],
    'Anagram filter' => test_zci('trifle', html => qr/.*/),
    'anagrams events' => test_zci('Steven', html => qr/.*/),
    'anagram of algorithm' => test_zci('logarithm', html => qr/.*/),
    'anagrams of favorite' => test_zci(qr/[favorite]{8}/, html => qr/.*/),
    'anagram of' => test_zci(qr/(of|fo)/, html => qr/.*/),
    'anagram filter 5' => test_zci('filet, flier, flirt, lifer, liter, refit, rifle', html => qr/.*/),
    'anagram times' => test_zci('emits, items, mites, smite', html => qr/.*/),
    'anagram Mixing it up' => test_zci(qr/[ Mixngtup]{12}/, html => qr/.*/),
    'anagram algorithm 14' => test_zci('logarithm', html => qr/.*/),
    'anagrams stop' => test_zci('Post, opts, post, pots, spot, tops', html => qr/.*/),
    'anagram stop'  => test_zci('Post, opts, post, pots, spot, tops', html => qr/.*/),
    'anagrams lost' => test_zci('lots, slot', html => qr/.*/),
    'anagram lost'  => test_zci('lots, slot', html => qr/.*/),
    'anagram of lost'  => test_zci('lots, slot', html => qr/.*/),
    'anagram of filter' => test_zci('trifle', html => qr/.*/),
    'anagram of Filter' => test_zci('trifle', html => qr/.*/),
);

done_testing;
