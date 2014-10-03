#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'anagram';
zci is_cached   => 0;

ddg_goodie_test(
    [qw(DDG::Goodie::Anagram)],
    'Anagram filter'       => test_zci('trifle',    html => qr/Anagrams of "filter"/),
    'anagrams events'      => test_zci('Steven',    html => qr/Anagrams of "events"/),
    'anagram of algorithm' => test_zci('logarithm', html => qr/Anagrams of "algorithm"/),
    'anagrams of favorite' => test_zci('favorite',  html => qr/we found no anagrams for "favorite".*scrambled it for you:/),
    'anagram of'           => test_zci('of',        html => qr/we found no anagrams for "of".*scrambled it for you:/),
    'anagram filter 5' => test_zci('filet, flier, flirt, lifer, liter, refit, rifle', html => qr/Anagrams of "filter" of length 5/),
    'anagram times'    => test_zci('emits, items, mites, smite',                      html => qr/Anagrams of "times"/),
    'anagram Mixing it up' => test_zci('Mixing it up', html => qr/we found no anagrams for "Mixing it up".*scrambled it for you:/),
    'anagram algorithm 14' => test_zci('logarithm',    html => qr/Anagrams of "algorithm"/),
    'anagrams stop'     => test_zci('Post, opts, post, pots, spot, tops', html => qr/Anagrams of "stop"/),
    'anagram stop'      => test_zci('Post, opts, post, pots, spot, tops', html => qr/Anagrams of "stop"/),
    'anagrams lost'     => test_zci('lots, slot',                         html => qr/Anagrams of "lost"/),
    'anagram lost'      => test_zci('lots, slot',                         html => qr/Anagrams of "lost"/),
    'anagram of lost'   => test_zci('lots, slot',                         html => qr/Anagrams of "lost"/),
    'anagram of filter' => test_zci('trifle',                             html => qr/Anagrams of "filter"/),
    'anagram of Filter' => test_zci('trifle',                             html => qr/Anagrams of "Filter"/),
    'anagrams of slot'  => test_zci(
        'lost, lots',
        html =>
          "<div class='zci--anagrams'><span class='text--secondary'>Anagrams of \"slot\"</span><br/><span class='text--primary'>lost, lots</span></div>"
    ),
);

done_testing;
