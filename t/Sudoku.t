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
	"play sudoku" => test_zci(
		qr/^[0-9_].*[0-9_]$/s,
		html => qr/.*\<table.*\<\/table\>.*/s,
	),
	"easy sudoku" => test_zci(
		qr/^[0-9_].*[0-9_]$/s,
		html => qr/.*\<table.*\<\/table\>.*/s,
	),
	"sudoku hard" => test_zci(
		qr/^[0-9_].*[0-9_]$/s,
		html => qr/.*\<table.*\<\/table\>.*/s,
	),
	"generate sudoku" => test_zci(
		qr/^[0-9_].*[0-9_]$/s,
		html => qr/.*\<table.*\<\/table\>.*/s,
	),
	"sudoku party" => undef,
	"sudoku toys" => undef,
);

done_testing;
