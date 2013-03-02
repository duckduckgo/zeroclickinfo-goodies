#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'anagram';
zci is_cached => 0;

ddg_goodie_test(
    [qw(DDG::Goodie::Anagram)],
    'Anagram filter' => test_zci('Anagram of "filter": trifle'),
    'anagrams events' => test_zci('Anagram of "events": Steven'),
    'anagram of algorithm' => test_zci('Anagram of "algorithm": logarithm'),
    'anagrams of favorite' => test_zci(qr/"favorite" scrambled: [favorite]{8}/),
    'anagram of' => test_zci(qr/"of" scrambled: (of|fo)/),
    'anagram filter 5' => test_zci('Anagrams of "filter" of size 5: filet, flier, flirt, lifer, liter, refit, rifle'),
    'anagram times' => test_zci('Anagrams of "times": emits, items, mites, smite'),
    'anagram Mixing it up' => test_zci(qr/"Mixing it up" scrambled: [ Mixngtup]{12}/),
    'anagram algorithm 14' => test_zci('Anagram of "algorithm": logarithm')
    );

done_testing;
