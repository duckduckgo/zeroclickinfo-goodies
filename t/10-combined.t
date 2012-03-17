#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

ddg_goodie_test(
	[qw(
		DDG::Goodie::ABC
		DDG::Goodie::Average
		DDG::Goodie::Base32
		DDG::Goodie::Binary
		DDG::Goodie::Capitalize
		DDG::Goodie::Dice
		DDG::Goodie::EmToPx
		DDG::Goodie::GoldenRatio
		DDG::Goodie::GUID
		DDG::Goodie::Length
		DDG::Goodie::Passphrase
		DDG::Goodie::PercentError
		DDG::Goodie::Perimeter
		DDG::Goodie::Reverse
		DDG::Goodie::Roman
		DDG::Goodie::SigFigs
		DDG::Goodie::TitleCase
		DDG::Goodie::Xor
		DDG::Goodie::PrivateNetwork
		DDG::Goodie::PublicDNS
	)],
	'reverse bla' => test_zci('alb', answer_type => 'reverse', is_cached => 1 ),
);

done_testing;

