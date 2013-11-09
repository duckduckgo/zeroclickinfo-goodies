#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'regex_cheat';

ddg_goodie_test(
	[
		# This is the name of the goodie that will be loaded to test.
		'DDG::Goodie::RegexCheatSheet'
	],
	# this one is really hard to actually test, so fudge it 
	'regex' => test_zci(
		qr/^Anchors.*|((Character|POSIX) Classes).*Pattern Modifiers.*Escape Sequences.*Groups and Ranges.*Assertions.*Special Characters.*String Replacement/s,
		html => qr#^<div(.*<table.*<tr.*<td.*</table.*)+</div>$#s
	),
	'regex ^' => test_zci(
		"^ - Start of string or line",
		html => "<code> ^ </code> - Start of string or line"
	),
	'regex $' => test_zci(
		'$ - End of string or line',
		html => '<code> $ </code> - End of string or line'
	),
	'regexp \s' => test_zci(
		'\s - Whitespace',
		html => '<code> \s </code> - Whitespace'
	),
	'regular expression [a-e]' => test_zci(
		'[a-e] - Single character range (a or b ... or e)',
		html => '<code> [a-e] </code> - Single character range (a or b ... or e)'
	),
	'regular expression [M-Y]' => test_zci(
		'[M-Y] - Single character range (M or N ... or Y)',
		html => '<code> [M-Y] </code> - Single character range (M or N ... or Y)'
	),
	'regex [1-2]' => test_zci(
		'[1-2] - Single character range (1 or 2)',
		html => '<code> [1-2] </code> - Single character range (1 or 2)'
	),
);

done_testing;