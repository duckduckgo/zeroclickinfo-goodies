#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'anagramsolver';
zci is_cached => 0;

# the regexps are kind of a hack, but it seemed better than not testing
# it at all
ddg_goodie_test(
    [qw(DDG::Goodie::AnagramSolver)],
    'anagram filter' => test_zci("anagram: trifle"),
    'anagrams events' => test_zci("anagram: Steven"),
    'anagram of algorithm' => test_zci("anagram: logarithm"),
    'anagrams of favorite' => test_zci(qr/\"favorite\" scrambled: [favorite]{8}/),
    'anagram of' => test_zci(qr/\"of\" scrambled: (of|fo)/),
    'anagram filter 5' => test_zci("Anagrams of filter of size 5: filet, flier, flirt, lifer, liter, refit, rifle"),
    'anagram times' => test_zci("anagrams: emits, items, mites, smite"),
    'anagram Mixing it up' => test_zci(qr/\"Mixing it up\" garbled: [ Mixngtup]{12}/),
    'anagram algorithm 14' => test_zci("anagram: logarithm")
    );

done_testing;
