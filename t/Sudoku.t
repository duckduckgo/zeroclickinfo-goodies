#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'sudoku';
zci is_cached => 0;

ddg_goodie_test(
	[
		'DDG::Goodie::Sudoku'
	],
	"sudoku" => test_zci(
		qr/^[0-9_].*[0-9_]$/s,
		html => qr/.*\<table.*\<\/table\>.*/s,
	),
);

done_testing;