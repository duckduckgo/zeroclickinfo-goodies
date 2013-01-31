#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'rand';
zci is_cached => 0;

ddg_goodie_test(
	[qw(
		DDG::Goodie::AorB
	)],
	'a or b' => test_zci(qr/(a|b) \(random\)/),
	'a b or c' => test_zci(qr/(a|b|c) \(random\)/),
	'choose a or b' => test_zci(qr/(a|b) \(random\)/),
	'choose a b or c' => test_zci(qr/(a|b) \(random\)/),
	'pick a or b' => test_zci(qr/(a|b) \(random\)/),
	'pick a b or c' => test_zci(qr/(a|b) \(random\)/),
	'@#$ or 1i4' => test_zci(qr/(@#$|1i4) \(random\)/),
);

done_testing;

