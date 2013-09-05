#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'leetspeak';
zci is_cached => 0;

ddg_goodie_test(
	[ 'DDG::Goodie::LeetSpeak'],
	'leetspeak hello world !' => test_zci('Leet Speak: |-|3|_|_0 \^/0|2|_|) !'),
	'l33tsp34k hElLo WORlD !' => test_zci('Leet Speak: |-|3|_|_0 \^/0|2|_|) !'),
	'what is l33t' => test_zci("Leet Speak: \\^/|-|/-\\'][' 15"),
	'leet speak leetspeak' => test_zci("Leet Speak: |_33']['5|D3/-\\|<"),
	'l33t sp34k /!§ ;€' => test_zci("Leet Speak: /!§ ;€"),
);

done_testing;
	
		

