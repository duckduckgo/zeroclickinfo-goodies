#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'translation';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::PigLatin
	)],
	'pig latin will this work?' => test_zci('Pig Latin: illway isthay orkway?'),
	'piglatin i love duckduckgo' => test_zci('Pig Latin: iway ovelay uckduckgoday'),
);

done_testing;
