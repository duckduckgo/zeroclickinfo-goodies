#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'spell';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Spell
	)],
	'spell foo' => test_zci("'Foo' appears to be spelled right!  Suggestions: foo, FPO, food, fool, foot, fop", html => "'Foo' appears to be spelled right!<br/>Suggestions: foo, FPO, food, fool, foot, fop"),
	'how do I spell foo' => test_zci("'Foo' appears to be spelled right!  Suggestions: foo, FPO, food, fool, foot, fop", html => "'Foo' appears to be spelled right!<br/>Suggestions: foo, FPO, food, fool, foot, fop"),
	'spellcheck hllo' => test_zci("'Hllo' does not appear to be spelled correctly.  Suggestions: hello, halo, halloo, hallow, hollow, Hall", html => "'Hllo' does not appear to be spelled correctly.<br/>Suggestions: hello, halo, halloo, hallow, hollow, Hall"),
);

done_testing;

