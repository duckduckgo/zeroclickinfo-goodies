#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "prime_factors";
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::PrimeFactors
	)],
		'72 prime factors' => test_zci('Prime factors of 72: 2 2 2 3 3.', html => 'Prime factors of 72: 2 2 2 3 3. More at <a href="https://en.wikipedia.org/wiki/Prime_factor">Wikipedia</a>.'),
		'prime factors of 111' => test_zci('Prime factors of 111: 3 37.', html => 'Prime factors of 111: 3 37. More at <a href="https://en.wikipedia.org/wiki/Prime_factor">Wikipedia</a>.'),
);

done_testing;
