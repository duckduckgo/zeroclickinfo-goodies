#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'duckduckgo';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::DuckDuckGo
	)],
	'Zero-Click Info' => test_zci("Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results."),
	'zeroclick' => test_zci("Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results."),
	'help' => test_zci("DuckDuckGo's help website: http://help.duckduckgo.com/", html => "DuckDuckGo's help website: <a href='http://help.duckduckgo.com/'>http://help.duckduckgo.com/</a>"),
);

done_testing;


