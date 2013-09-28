#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DDG::Test::Location;
use DDG::Request;
use utf8;

zci answer_type => 'loan';
zci is_cached => 1;

ddg_goodie_test (
	[
		'DDG::Goodie::Loan'
	],
	'loan 400000 4.5%' =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	'loan $400000 at 4.5%' =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	'loan $500000 at 4.5% with 20% down' =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	'loan $500000 at 4.5% with $100000 down' =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	'loan $250000 3% interest 15 years' =>
		test_zci('Monthly Payment is $1,726.45 for 15 years. Total interest paid is $60,761.74'),
	'loan $300000 at 3% interest with $50000 downpayment for 15 years' =>
		test_zci('Monthly Payment is $1,726.45 for 15 years. Total interest paid is $60,761.74'),
	'loan $300000 3% $50000 down 15 year' =>
		test_zci('Monthly Payment is $1,726.45 for 15 years. Total interest paid is $60,761.74'),
	'loan €400000 at 4.5%' =>
		test_zci('Monthly Payment is €2.026,74 for 30 years. Total interest paid is €329.626,85'),
	'loan £250000 3% interest 15 years' =>
		test_zci('Monthly Payment is £1,726.45 for 15 years. Total interest paid is £60,761.74'),
	'loan $400,000.00 at 4.5%' =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	'loan €250.000,00 3% interest 15 years' =>
		test_zci('Monthly Payment is €1.726,45 for 15 years. Total interest paid is €60.761,74'),
	# Test a few cases of inferring user's location
	DDG::Request->new(query_raw => "loan 400000 4.5%", location => test_location("de")) =>
		test_zci('Monthly Payment is €2.026,74 for 30 years. Total interest paid is €329.626,85'),
	DDG::Request->new(query_raw => "loan 400000 4.5%", location => test_location("in")) =>
		test_zci('Monthly Payment is ₨2,026.74 for 30 years. Total interest paid is ₨329,626.85'),
	DDG::Request->new(query_raw => "loan 400000 4.5%", location => test_location("my")) =>
		test_zci('Monthly Payment is 2,026.74 MYR for 30 years. Total interest paid is 329,626.85 MYR'),
	# Test that symbol overrides user's location
	DDG::Request->new(query_raw => "loan \$400,000 4.5%", location => test_location("de")) =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	# Imagine a new country later appears, test defaulting to USD because we don't know about it
	DDG::Request->new(query_raw => "loan 400000 4.5%", location => DDG::Location->new(
			{
				country_code => 'LL',
				country_code3 => 'LLA',
				country_name => 'Llama Land',
				region => '9',
				region_name => 'Llama Region',
				city => 'New Llama City',
				latitude => '90.0000',
				longitude => '0.0000',
				time_zone => 'America/New_York',
				area_code => 0,
				continent_code => 'NA',
				metro_code => 0
			}
		)) =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85')
);

done_testing;
