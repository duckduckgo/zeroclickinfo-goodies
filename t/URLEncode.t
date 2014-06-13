#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'encoded_url';

ddg_goodie_test(
	[qw(DDG::Goodie::URLEncode)],
	# Test 1
		'url encode http://nospaces.duckduckgo.com/hook em horns' => test_zci("Encoded URL: http://nospaces.duckduckgo.com/hook%20em%20horns",
		html => "<div>Encoded URL: http://nospaces.duckduckgo.com/hook%20em%20horns</div><div>More at <a href=\"https://en.wikipedia.org/wiki/Url_encoding\">Wikipedia</a></div>"),
	# Test 2
		'encode url xkcd.com/a webcomic of%romance+math+sarcasm+language' => test_zci("Encoded URL: xkcd.com/a%20webcomic%20of%25romance+math+sarcasm+language",
		html => "<div>Encoded URL: xkcd.com/a%20webcomic%20of%25romance+math+sarcasm+language</div><div>More at <a href=\"https://en.wikipedia.org/wiki/Url_encoding\">Wikipedia</a></div>"),
	# Test 3
		'http://arstechnica.com/space after end  url encode' => test_zci("Encoded URL: http://arstechnica.com/space%20after%20end%20",
		html => "<div>Encoded URL: http://arstechnica.com/space%20after%20end%20</div><div>More at <a href=\"https://en.wikipedia.org/wiki/Url_encoding\">Wikipedia</a></div>"),
	# Test 4
		'apple.com/mac encode URL' => test_zci("Encoded URL: apple.com/mac",
		html => "<div>Encoded URL: apple.com/mac</div><div>More at <a href=\"https://en.wikipedia.org/wiki/Url_encoding\">Wikipedia</a></div>"),		
);

done_testing;