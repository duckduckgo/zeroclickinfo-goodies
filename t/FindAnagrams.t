#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'findanagrams';
zci is_cached => 1;

ddg_goodie_test(
	[qw(DDG::Goodie::FindAnagrams)],

    "anagrams stop" => test_zci("Post, opts, post, pots, spot, tops"),
    "anagram stop"  => test_zci("Post, opts, post, pots, spot, tops"),
    "anagrams lost" => test_zci("lots, slot"),  
    "anagram lost"  => test_zci("lots, slot"), 
);

done_testing;

