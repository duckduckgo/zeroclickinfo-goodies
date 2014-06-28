#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'decimal';
zci is_cached   => 0;

ddg_goodie_test(
	[qw( DDG::Goodie::HexToDec )],
	'0xd1038d2e07b42569' => test_zci('15061036807694329193'),
	'0x44696f21' => test_zci('1147760417'),
    '0x44696f2Z' => undef,
);

done_testing;

