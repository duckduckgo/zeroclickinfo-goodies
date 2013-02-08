#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'idn';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::IDN
	)],
	'idn exämple.com' => test_zci('Encoded IDN: xn--exmple-cua.com'),
	'idn xn--exmple-cua.com' => test_zci('Decoded IDN: ex&auml;mple.com'),
);

done_testing;

