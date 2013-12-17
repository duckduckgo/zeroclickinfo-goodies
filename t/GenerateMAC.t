#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "MAC Address";
zci is_cached => 0;

my $mac_regxp = "([0-9A-F]{2}[:-]){5}([0-9A-F]{2})";
my $text_start = "Here's a random MAC address: <b>";
my $text_end = "</b> <br /> More information at <a href='http://coffer.com/mac_find/'>coffer.com</a>";

#regexp from http://stackoverflow.com/questions/4260467/what-is-a-regular-expression-for-a-mac-address
ddg_goodie_test (
	[
		'DDG::Goodie::GenerateMAC'
	],
	'generate mac address' => 
		test_zci(
			qr/^$mac_regxp$/, 
			html => qr//,
		),
	'generate mac addr' => 
		test_zci(
			qr/^$mac_regxp$/, 
			html => qr//,
		),
	'random mac address' => 
		test_zci(
			qr/^$mac_regxp$/, 
			html => qr//,
		),
	'random mac addr' => 
		test_zci(
			qr/^$mac_regxp$/, 
			html => qr//,
		),
);

done_testing;