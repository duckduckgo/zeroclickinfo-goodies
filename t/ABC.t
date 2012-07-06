#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'rand';
zci is_cached => 0;

ddg_goodie_test(
	[qw(
		DDG::Goodie::ABC
	)],
	'yes or no' => test_zci(qr/(yes|no) \(random\)/),
    "this or that or none" => test_zci(qr/(this|that|none) \(random\)/),
    "duckduckgo or google or bing or something" => test_zci("duckduckgo (not random)", answer_type => 'egg'),
    "DuckDuckGo OR Google OR Bing or SOMETHING" => test_zci("DuckDuckGo (not random)", answer_type => 'egg'),
);

done_testing;

