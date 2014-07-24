#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'rand';
zci is_cached => 0;
zci type => 'E';

ddg_goodie_test(
	[qw(
		DDG::Goodie::RandomNumber
	)],
	'random number between 12 and 45' => test_zci( qr/\d{2} \(random number\)/),
	'random number' => test_zci( qr/\d{1}\.\d{16} \(random number\)/)
);
done_testing
