#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DDG::Test::Location;
use DDG::Request;
use utf8;

zci answer_type => 'loan';
zci is_cached   => 1;

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
	'loan 250.000,00 EUR 3% interest 15 years' =>
		test_zci('Monthly Payment is €1.726,45 for 15 years. Total interest paid is €60.761,74'),
	'loan 500000 EUR at 4.5% 100000 EUR down' =>
		test_zci('Monthly Payment is €2.026,74 for 30 years. Total interest paid is €329.626,85'),
	'loan for 23000 with 5000 down and 12% interest' =>
		test_zci('Monthly Payment is $185.15 for 30 years. Total interest paid is $48,654.10'),
	'loan 50000 usd at 1% 1 usd down' =>
		test_zci('Monthly Payment is $160.82 for 30 years. Total interest paid is $7,894.96'),
	'loan 5 usd at 1% 1 usd down' =>
		test_zci('Monthly Payment is $0.01 for 30 years. Total interest paid is $0.63'),
	'5 year loan with 3% interest on $23,000 1000 down' =>
		test_zci('Monthly Payment is $395.31 for 5 years. Total interest paid is $1,718.67'),
	'loan with $1000 down at 3% for $23,000 for 5 years' =>
		test_zci('Monthly Payment is $395.31 for 5 years. Total interest paid is $1,718.67'),
	'borrow 400000 4.5%' =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	'borrow $400000 at 4.5%' =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	'borrow $500000 at 4.5% with 20% down' =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	'borrow $500000 at 4.5% with $100000 down' =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	'borrow $250000 3% interest 15 years' =>
		test_zci('Monthly Payment is $1,726.45 for 15 years. Total interest paid is $60,761.74'),
	'borrow $300000 at 3% interest with $50000 downpayment for 15 years' =>
		test_zci('Monthly Payment is $1,726.45 for 15 years. Total interest paid is $60,761.74'),
	'borrow $300000 3% $50000 down 15 year' =>
		test_zci('Monthly Payment is $1,726.45 for 15 years. Total interest paid is $60,761.74'),
	'borrow €400000 at 4.5%' =>
		test_zci('Monthly Payment is €2.026,74 for 30 years. Total interest paid is €329.626,85'),
	'borrow £250000 3% interest 15 years' =>
		test_zci('Monthly Payment is £1,726.45 for 15 years. Total interest paid is £60,761.74'),
	'borrow $400,000.00 at 4.5%' =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	'borrow €250.000,00 3% interest 15 years' =>
		test_zci('Monthly Payment is €1.726,45 for 15 years. Total interest paid is €60.761,74'),
	'borrow 250.000,00 EUR 3% interest 15 years' =>
		test_zci('Monthly Payment is €1.726,45 for 15 years. Total interest paid is €60.761,74'),
	'borrow 500000 EUR at 4.5% 100000 EUR down' =>
		test_zci('Monthly Payment is €2.026,74 for 30 years. Total interest paid is €329.626,85'),
	'borrow for 23000 with 5000 down and 12% interest' =>
		test_zci('Monthly Payment is $185.15 for 30 years. Total interest paid is $48,654.10'),
	'borrow 50000 usd at 1% 1 usd down' =>
		test_zci('Monthly Payment is $160.82 for 30 years. Total interest paid is $7,894.96'),
	'borrow 5 usd at 1% 1 usd down' =>
		test_zci('Monthly Payment is $0.01 for 30 years. Total interest paid is $0.63'),
	'5 year borrow with 3% interest on $23,000 1000 down' =>
		test_zci('Monthly Payment is $395.31 for 5 years. Total interest paid is $1,718.67'),
	'borrow with $1000 down at 3% for $23,000 for 5 years' =>
		test_zci('Monthly Payment is $395.31 for 5 years. Total interest paid is $1,718.67'),
	'mortgage 400000 4.5%' =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	'mortgage $400000 at 4.5%' =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	'mortgage $500000 at 4.5% with 20% down' =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	'mortgage $500000 at 4.5% with $100000 down' =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	'mortgage $250000 3% interest 15 years' =>
		test_zci('Monthly Payment is $1,726.45 for 15 years. Total interest paid is $60,761.74'),
	'mortgage $300000 at 3% interest with $50000 downpayment for 15 years' =>
		test_zci('Monthly Payment is $1,726.45 for 15 years. Total interest paid is $60,761.74'),
	'mortgage $300000 3% $50000 down 15 year' =>
		test_zci('Monthly Payment is $1,726.45 for 15 years. Total interest paid is $60,761.74'),
	'mortgage €400000 at 4.5%' =>
		test_zci('Monthly Payment is €2.026,74 for 30 years. Total interest paid is €329.626,85'),
	'mortgage £250000 3% interest 15 years' =>
		test_zci('Monthly Payment is £1,726.45 for 15 years. Total interest paid is £60,761.74'),
	'mortgage $400,000.00 at 4.5%' =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	'mortgage €250.000,00 3% interest 15 years' =>
		test_zci('Monthly Payment is €1.726,45 for 15 years. Total interest paid is €60.761,74'),
	'mortgage 250.000,00 EUR 3% interest 15 years' =>
		test_zci('Monthly Payment is €1.726,45 for 15 years. Total interest paid is €60.761,74'),
	'mortgage 500000 EUR at 4.5% 100000 EUR down' =>
		test_zci('Monthly Payment is €2.026,74 for 30 years. Total interest paid is €329.626,85'),
	'mortgage for 23000 with 5000 down and 12% interest' =>
		test_zci('Monthly Payment is $185.15 for 30 years. Total interest paid is $48,654.10'),
	'mortgage 50000 usd at 1% 1 usd down' =>
		test_zci('Monthly Payment is $160.82 for 30 years. Total interest paid is $7,894.96'),
	'mortgage 5 usd at 1% 1 usd down' =>
		test_zci('Monthly Payment is $0.01 for 30 years. Total interest paid is $0.63'),
	'5 year mortgage with 3% interest on $23,000 1000 down' =>
		test_zci('Monthly Payment is $395.31 for 5 years. Total interest paid is $1,718.67'),
	'loan with $1000 down at 3% for $23,000 for 5 years' =>
		test_zci('Monthly Payment is $395.31 for 5 years. Total interest paid is $1,718.67'),

	# Test a few cases of inferring user's location with 'loan' trigger word
	DDG::Request->new(query_raw => "loan 400000 4.5%", location => test_location("de")) =>
		test_zci('Monthly Payment is €2.026,74 for 30 years. Total interest paid is €329.626,85'),
	DDG::Request->new(query_raw => "loan 400000 4.5%", location => test_location("in")) =>
		test_zci('Monthly Payment is ₨2,026.74 for 30 years. Total interest paid is ₨329,626.85'),
        # Given a common currency symbol and location, make sure we get the correct currency
	DDG::Request->new(query_raw => "loan \$400000 4.5%", location => test_location("au")) =>
		test_zci('Monthly Payment is $2 026.74 for 30 years. Total interest paid is $329 626.85'),
	# Malaysia has no symbol, just the currency code after the amounts
	DDG::Request->new(query_raw => "loan 400000 MYR at 4.5%", location => test_location("my")) =>
		test_zci('Monthly Payment is 2,026.74 MYR for 30 years. Total interest paid is 329,626.85 MYR'),
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
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),

	# Test a few cases of inferring user's location with 'borrow' trigger word
	DDG::Request->new(query_raw => "borrow 400000 4.5%", location => test_location("de")) =>
		test_zci('Monthly Payment is €2.026,74 for 30 years. Total interest paid is €329.626,85'),
	DDG::Request->new(query_raw => "borrow 400000 4.5%", location => test_location("in")) =>
		test_zci('Monthly Payment is ₨2,026.74 for 30 years. Total interest paid is ₨329,626.85'),
        # Given a common currency symbol and location, make sure we get the correct currency
	DDG::Request->new(query_raw => "borrow \$400000 4.5%", location => test_location("au")) =>
		test_zci('Monthly Payment is $2 026.74 for 30 years. Total interest paid is $329 626.85'),
	# Malaysia has no symbol, just the currency code after the amounts
	DDG::Request->new(query_raw => "borrow 400000 MYR at 4.5%", location => test_location("my")) =>
		test_zci('Monthly Payment is 2,026.74 MYR for 30 years. Total interest paid is 329,626.85 MYR'),
	DDG::Request->new(query_raw => "borrow 400000 4.5%", location => test_location("my")) =>
		test_zci('Monthly Payment is 2,026.74 MYR for 30 years. Total interest paid is 329,626.85 MYR'),
	# Test that symbol overrides user's location
	DDG::Request->new(query_raw => "borrow \$400,000 4.5%", location => test_location("de")) =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	# Imagine a new country later appears, test defaulting to USD because we don't know about it
	DDG::Request->new(query_raw => "borrow 400000 4.5%", location => DDG::Location->new(
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
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),

	# Test a few cases of inferring user's location with 'mortgage' trigger word
	DDG::Request->new(query_raw => "mortgage 400000 4.5%", location => test_location("de")) =>
		test_zci('Monthly Payment is €2.026,74 for 30 years. Total interest paid is €329.626,85'),
	DDG::Request->new(query_raw => "mortgage 400000 4.5%", location => test_location("in")) =>
		test_zci('Monthly Payment is ₨2,026.74 for 30 years. Total interest paid is ₨329,626.85'),
        # Given a common currency symbol and location, make sure we get the correct currency
	DDG::Request->new(query_raw => "mortgage \$400000 4.5%", location => test_location("au")) =>
		test_zci('Monthly Payment is $2 026.74 for 30 years. Total interest paid is $329 626.85'),
	# Malaysia has no symbol, just the currency code after the amounts
	DDG::Request->new(query_raw => "mortgage 400000 MYR at 4.5%", location => test_location("my")) =>
		test_zci('Monthly Payment is 2,026.74 MYR for 30 years. Total interest paid is 329,626.85 MYR'),
	DDG::Request->new(query_raw => "mortgage 400000 4.5%", location => test_location("my")) =>
		test_zci('Monthly Payment is 2,026.74 MYR for 30 years. Total interest paid is 329,626.85 MYR'),
	# Test that symbol overrides user's location
	DDG::Request->new(query_raw => "mortgage \$400,000 4.5%", location => test_location("de")) =>
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
	# Imagine a new country later appears, test defaulting to USD because we don't know about it
	DDG::Request->new(query_raw => "mortgage 400000 4.5%", location => DDG::Location->new(
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
		test_zci('Monthly Payment is $2,026.74 for 30 years. Total interest paid is $329,626.85'),
    'loan $500000 at 4.5% with 20% down 15 years' =>
        test_zci('Monthly Payment is $3,059.97 for 15 years. Total interest paid is $150,795.17'),
    'borrow $500000 4.5%' =>
        test_zci('Monthly Payment is $2,533.43 for 30 years. Total interest paid is $412,033.56'),
    'mortgage $500000 4.5% 20% down 15 years' =>
        test_zci('Monthly Payment is $3,059.97 for 15 years. Total interest paid is $150,795.17'),
);


done_testing;
