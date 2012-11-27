#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'guid';
zci is_cached => 0;

ddg_goodie_test(
	[qw(
		DDG::Goodie::GUID
	)],
	'guid' => test_zci(qr/ \(randomly generated\)$/),
	'uuid' => test_zci(qr/ \(randomly generated\)$/),
	'globally unique identifier' => test_zci(qr/ \(randomly generated\)$/),
	'rfc 4122' => test_zci(qr/ \(randomly generated\)$/),
);

done_testing;

