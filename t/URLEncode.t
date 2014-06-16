#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'encoded_url';

ddg_goodie_test(
	[qw(DDG::Goodie::URLEncode)],
	# Test 1 - simple
	'url encode http://nospaces.duckduckgo.com/hook em horns' => test_zci("Encoded URL: http://nospaces.duckduckgo.com/hook%20em%20horns",
	html => "<div>Encoded URL: http://nospaces.duckduckgo.com/hook%20em%20horns</div><div><a class=\"zci__more-at\" href=\"https://en.wikipedia.org/wiki/Url_encoding\">More at Wikipedia</a></div>"),
	# Test 2 - with spaces
	'encode url xkcd.com/a webcomic of%romance+math+sarcasm+language' => test_zci("Encoded URL: xkcd.com/a%20webcomic%20of%25romance+math+sarcasm+language",
	html => "<div>Encoded URL: xkcd.com/a%20webcomic%20of%25romance+math+sarcasm+language</div><div><a class=\"zci__more-at\" href=\"https://en.wikipedia.org/wiki/Url_encoding\">More at Wikipedia</a></div>"),
	# Test 3 - spaces between keyword and query data 
	'http://arstechnica.com/space after end  url encode' => test_zci("Encoded URL: http://arstechnica.com/space%20after%20end%20",
	html => "<div>Encoded URL: http://arstechnica.com/space%20after%20end%20</div><div><a class=\"zci__more-at\" href=\"https://en.wikipedia.org/wiki/Url_encoding\">More at Wikipedia</a></div>"),
	# Test 4 - nothing to encode
	'apple.com/mac encode URL' => test_zci("Encoded URL: apple.com/mac",
	html => "<div>Encoded URL: apple.com/mac</div><div><a class=\"zci__more-at\" href=\"https://en.wikipedia.org/wiki/Url_encoding\">More at Wikipedia</a></div>"),
	# Test 5 - new triggers
	'https://example.com/zero#clickinfo^34* encodeurl' => test_zci("Encoded URL: https://example.com/zero#clickinfo%5E34*",
	html => "<div>Encoded URL: https://example.com/zero#clickinfo%5E34*</div><div><a class=\"zci__more-at\" href=\"https://en.wikipedia.org/wiki/Url_encoding\">More at Wikipedia</a></div>"),
	# Test 6 - more characters to convert / new trigger
	'urlencode https://example.org/the answer to"life%the-universe.and<>everything\|}{' => test_zci("Encoded URL: https://example.org/the%20answer%20to%22life%25the-universe.and%3C%3Eeverything%5C%7C%7D%7B",
	html => "<div>Encoded URL: https://example.org/the%20answer%20to%22life%25the-universe.and%3C%3Eeverything%5C%7C%7D%7B</div><div><a class=\"zci__more-at\" href=\"https://en.wikipedia.org/wiki/Url_encoding\">More at Wikipedia</a></div>"),
	# Test 7 - even more characters / new trigger
	'urlescape https://example.org/the-alchemist_`purified gold...in&the/middle!OfTheSandstorm' => test_zci("Encoded URL: https://example.org/the-alchemist_%60purified%20gold...in&the/middle!OfTheSandstorm",
	html => "<div>Encoded URL: https://example.org/the-alchemist_%60purified%20gold...in&the/middle!OfTheSandstorm</div><div><a class=\"zci__more-at\" href=\"https://en.wikipedia.org/wiki/Url_encoding\">More at Wikipedia</a></div>"),
	# Test 8 - brackets and parantheses / new trigger
	'www.herokuapp.com/(){}[] urlencode' => test_zci("Encoded URL: www.herokuapp.com/()%7B%7D[]",
	html => "<div>Encoded URL: www.herokuapp.com/()%7B%7D[]</div><div><a class=\"zci__more-at\" href=\"https://en.wikipedia.org/wiki/Url_encoding\">More at Wikipedia</a></div>"),		
);

done_testing;
