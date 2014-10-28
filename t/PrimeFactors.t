#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => "prime_factors";
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::PrimeFactors
	)],
    '72 prime factors' => test_zci('The prime factorization of 72 is 2^3 × 3^2',
				   html => 'The prime factorization of 72 is 2<sup>3</sup> × 3<sup>2</sup>'),
    'prime factors of 111' => test_zci('The prime factorization of 111 is 3 × 37',
				       html => 'The prime factorization of 111 is 3 × 37'),
    'prime factors of 30' => test_zci('The prime factorization of 30 is 2 × 3 × 5',
				      html => 'The prime factorization of 30 is 2 × 3 × 5'),
    'prime factorization of 45' => test_zci('The prime factorization of 45 is 3^2 × 5',
					    html => 'The prime factorization of 45 is 3<sup>2</sup> × 5'),
    'factorize 128' => test_zci('The prime factorization of 128 is 2^7',
					    html => 'The prime factorization of 128 is 2<sup>7</sup>'),
    '42 prime factorize' => test_zci('The prime factorization of 42 is 2 × 3 × 7',
					    html => 'The prime factorization of 42 is 2 × 3 × 7'),
    'optimus prime 45' => undef,
);

done_testing;
