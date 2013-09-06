#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'loan';
zci is_cached => 1;

ddg_goodie_test (
	[
		'DDG::Goodie::Loan'
	],
	'loan 400000 4.5%' =>
		test_zci('Monthly Payment is $2026.74 for 30 years. Total interest paid is $329626.85'),
	'loan $400000 at 4.5%' =>
		test_zci('Monthly Payment is $2026.74 for 30 years. Total interest paid is $329626.85'),
	'loan $500000 at 4.5% with 20% down' =>
		test_zci('Monthly Payment is $2026.74 for 30 years. Total interest paid is $329626.85'),
	'loan $500000 at 4.5% with $100000 down' =>
		test_zci('Monthly Payment is $2026.74 for 30 years. Total interest paid is $329626.85'),
	'loan $250000 3% interest 15 years' =>
		test_zci('Monthly Payment is $1726.45 for 15 years. Total interest paid is $60761.74'),
	'loan $300000 at 3% interest with $50000 downpayment for 15 years' =>
		test_zci('Monthly Payment is $1726.45 for 15 years. Total interest paid is $60761.74'),
	'loan $300000 3% $50000 down 15 year' =>
		test_zci('Monthly Payment is $1726.45 for 15 years. Total interest paid is $60761.74')
);

done_testing;
