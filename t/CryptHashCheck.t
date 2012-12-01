#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'crypt_hash_check';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::CryptHashCheck
	)],
	'hash 5c0847eccfaeabf4a0207d42a2986992' => test_zci('This is MD5 cryptographic hash function.'),
	'md5 ecaceaca62d6c47190ed6c6f94a298f28a46450fda0bd1ec8fc64bc4a7a8cd436791a35f3c4e339b7ae480c1b751f1c1' => test_zci('This is SHA-2/384 cryptographic hash function.'),
	'sha b1d7eb51d4372c505446abca04835a101275e498' => test_zci('This is SHA-1/40 cryptographic hash function.'),
	'hash 6286e0a5cbc030f7b2d105f594ae0afb9105c92175c6b07ff454734c23cd0bddfed77639fe59b68a70b8c78af27657f611cbe89c27f7a47b978fa9449808c19f' => test_zci('This is SHA-2/512 cryptographic hash function.'),
	'md5 a8a35ab9036388fd42fe1d73d93ede7ec604044ba4753259fafbf718' => test_zci('This is SHA-2/224 cryptographic hash function.'),
	
);

done_testing;
