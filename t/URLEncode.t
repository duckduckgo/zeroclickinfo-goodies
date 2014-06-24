#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'encoded_url';

ddg_goodie_test(
    [qw(DDG::Goodie::URLEncode)],
    # Test 1 - simple
    'url encode http://nospaces.duckduckgo.com/hook em horns' => test_zci("Percent-encoded URL: http://nospaces.duckduckgo.com/hook%20em%20horns",
    html => qr/http:\/\/nospaces.duckduckgo.com\/hook%20em%20horns/),
    # Test 2 - with spaces
    'encode url xkcd.com/a webcomic of%romance+math+sarcasm+language' => test_zci("Percent-encoded URL: xkcd.com/a%20webcomic%20of%25romance+math+sarcasm+language",
    html => qr/xkcd.com\/a%20webcomic%20of%25romance\+math\+sarcasm\+language/),
    # Test 3 - spaces between keyword and query data 
    'http://arstechnica.com/space after end  url encode' => test_zci("Percent-encoded URL: http://arstechnica.com/space%20after%20end%20",
    html => qr/http:\/\/arstechnica.com\/space%20after%20end%20/),
    # Test 4 - nothing to encode
    'apple.com/mac encode URL' => test_zci("Percent-encoded URL: apple.com/mac",
    html => qr/apple.com\/mac/),
    # Test 5 - new triggers
    'https://example.com/zero#clickinfo^34* encodeurl' => test_zci("Percent-encoded URL: https://example.com/zero#clickinfo%5E34*",
    html => qr/https:\/\/example.com\/zero#clickinfo%5E34*/),
    # Test 6 - more characters to convert
    'url escape https://example.org/the answer to"life%the-universe.and<>everything\|}{' => test_zci("Percent-encoded URL: https://example.org/the%20answer%20to%22life%25the-universe.and%3C%3Eeverything%5C%7C%7D%7B",
    html => qr/https:\/\/example.org\/the%20answer%20to%22life%25the-universe.and%3C%3Eeverything%5C%7C%7D%7B/),
    # Test 7 - even more characters
    'urlescape https://example.org/the-alchemist_`purified gold...in&the/middle!OfTheSandstorm' => test_zci("Percent-encoded URL: https://example.org/the-alchemist_%60purified%20gold...in&the/middle!OfTheSandstorm",
    html => qr/https:\/\/example.org\/the-alchemist_%60purified%20gold...in&the\/middle!OfTheSandstorm/),
    # Test 8 - brackets and parantheses
    'www.herokuapp.com/(){}[] urlencode' => test_zci("Percent-encoded URL: www.herokuapp.com/()%7B%7D[]",
    html => qr/www.herokuapp.com\/\(\)%7B%7D\[\]/),
);

done_testing;
