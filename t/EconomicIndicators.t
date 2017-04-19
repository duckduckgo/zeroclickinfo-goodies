#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "economic_indicators";
zci is_cached   => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::EconomicIndicators
	)],
	# primary example queries
	'what is the per capita income of china' => test_zci('Per Capita Income of China (2013)  11850 USD', html=>qr/.*/),
	'per capita income, japan' => test_zci('Per Capita Income of Japan (2013)  37630 USD', html=>qr/.*/),
	'what is the growth rate of indonesia' => test_zci('Annual Growth Rate of Indonesia (2013)  5.78 %', html=>qr/.*/),
	'malaysia growth rate' => test_zci('Annual Growth Rate of Malaysia (2013)  4.69 %', html=>qr/.*/),
	'gdp of india' => test_zci('Gross Domestic Product of India (2013)  1.877 Trillion USD', html=>qr/.*/),
	'sri lanka gdp' => test_zci('Gross Domestic Product of Sri Lanka (2013)  67.182 Billion USD', html=>qr/.*/),
	# question marks
	'what is the gross domestic product of singapore?' => test_zci('Gross Domestic Product of Singapore (2013)  297.941 Billion USD', html=>qr/.*/),
	# some aliases
	'gdp of antigua' => test_zci('Gross Domestic Product of Antigua and Barbuda (2013)  1.230 Billion USD', html=>qr/.*/),
	'per capita income of st vincent' => test_zci('Per Capita Income of St Vincent and Grenadines (2013)  10610 USD',html=>qr/.*/),
	'usa gdp' => test_zci('Gross Domestic Product of United States (2013)  16.800 Trillion USD', html=>qr/.*/),
);

done_testing;
