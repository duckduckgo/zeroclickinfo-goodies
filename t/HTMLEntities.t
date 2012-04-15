#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'html_entity';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::HTMLEntities
	)],
	'&#33;' => test_zci("Decoded HTML Entity: !, decimal: 33, hexadecimal: 0021", html => "Decoded HTML Entity: !, decimal: 33, hexadecimal: <a href=\"/?q=U%2B0021\">0021</a>"),
	'&#x21' => test_zci("Decoded HTML Entity: !, decimal: 33, hexadecimal: 0021", html => "Decoded HTML Entity: !, decimal: 33, hexadecimal: <a href=\"/?q=U%2B0021\">0021</a>"),
	'html entity &amp;' => test_zci("Decoded HTML Entity: &, decimal: 38, hexadecimal: 0026", html => "Decoded HTML Entity: &, decimal: 38, hexadecimal: <a href=\"/?q=U%2B0026\">0026</a>"),
);

done_testing;

