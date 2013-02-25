#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'anagramsolver';
zci is_cached => 0;

ddg_goodie_test(
    [qw(DDG::Goodie::AnagramSolver)],
    'anagram filter' => test_zci(qr/\"filter\" garbled: [filter]{6}, with proper anagram: trifle/),
    'anagrams filter' => test_zci(qr/\"filter\" garbled: [filter]{6}, with proper anagram: trifle/),
    'anagram filter 5' => test_zci("Anagrams of filter of size 5: filet, flier, flirt, lifer, liter, refit, rifle"),
    'anagram favorite' => test_zci(qr/\"favorite\" garbled: [favorite]{8}/),
    'anagram times' => test_zci(qr/\"times\" garbled: [times]{5}, with proper anagrams: emits, items, mites, smite/),
    'anagram algorithm' => test_zci(qr/\"algorithm\" garbled: [algorithm]{9}, with proper anagram: logarithm/),
    'anagram Mixing it up' => test_zci(qr/\"Mixing it up\" garbled: [ Mixngtup]{12}/),
    'anagram algorithm 14' => test_zci(qr/\"algorithm\" garbled: [algorithm]{9}, with proper anagram: logarithm/)
    );

done_testing;
