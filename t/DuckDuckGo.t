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
	'duckduckgo Zero-Click Info' => test_zci("", html => "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results."),
	'ddg zeroclick' => test_zci("", html => "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results."),
#	'duckduckgo help' => test_zci("DuckDuckGo's help website: http://dukgo.com/help/", html => "DuckDuckGo's help website: <a href='http://dukgo.com/help/'>http://dukgo.com/help/</a>"),
	'duckduckgo irc' => test_zci("", html => "DuckDuckGo's official IRC channel is <a href='http://webchat.freenode.net/?channels=duckduckgo'>#duckduckgo</a> on <a href='http://freenode.net/'>irc.freenode.net</a>"),
	irc => undef,
);

done_testing;


