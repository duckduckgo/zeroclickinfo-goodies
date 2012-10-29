#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'string';
zci is_cached => 0;

ddg_goodie_test(
	[qw(DDG::Goodie::FindAnagrams)],

    "Find Anagrams"   => test_zci("No Anagrams Found."),
    "Find Anagrams <>"   => test_zci("No Anagrams Found."),
    "Find Anagrams stop"   => test_zci("Post opts post pots spot tops"),
    "Find Anagrams lost" => test_zci("lots, slot"),
);

done_testing;

