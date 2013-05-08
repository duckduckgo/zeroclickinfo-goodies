#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'minecraft skin';
zci is_cached => 1;

ddg_goodie_test{
	[qw( DDG::Goodie::MinecraftSkin )],
	'minecraft skin teamnigel' => test_zci(
		"teamnigel",
		html => qq(<img src="https://minotar.net/avatar/' . $_ . '/64.png"> <img src="https://minotar.net/skin/' . $_ . '">)
	),
	'minotar teamnigel' => test_zci(
		"teamnigel",
		html => qq(<img src="https://minotar.net/avatar/' . $_ . '/64.png"> <img src="https://minotar.net/skin/' . $_ . '">)
	),
	'teamnigel minecraftskin' => test_zci(
		"teamnigel",
		html => qq(<img src="https://minotar.net/avatar/' . $_ . '/64.png"> <img src="https://minotar.net/skin/' . $_ . '">)
	),
