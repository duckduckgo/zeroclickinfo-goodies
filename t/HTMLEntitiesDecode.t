#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'html_entity';

ddg_goodie_test(
	[qw(DDG::Goodie::HTMLEntitiesDecode)],
	# Test 1
		'html decode &#33;' => test_zci("Decoded HTML Entity: !, decimal: 33, hexadecimal: 0021", html => "Decoded HTML Entity: &#33;, decimal: 33, hexadecimal: <a href=\"/?q=U%2B0021\">0021</a>"),
	# Test 2
		'html decode &amp;' => test_zci("Decoded HTML Entity: &, decimal: 38, hexadecimal: 0026", html => "Decoded HTML Entity: &amp;, decimal: 38, hexadecimal: <a href=\"/?q=U%2B0026\">0026</a>"),
	# Test 3
		'&#x21 decode html' => test_zci("Decoded HTML Entity: !, decimal: 33, hexadecimal: 0021", html => "Decoded HTML Entity: &#x21;, decimal: 33, hexadecimal: <a href=\"/?q=U%2B0021\">0021</a>"),
	# Test 4
		'#36 html decode' => test_zci("Decoded HTML Entity: \$, decimal: 36, hexadecimal: 0024", html => "Decoded HTML Entity: &#36;, decimal: 36, hexadecimal: <a href=\"/?q=U%2B0024\">0024</a>"),
);

done_testing;
