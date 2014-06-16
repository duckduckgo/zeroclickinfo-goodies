#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'html_entity';

ddg_goodie_test(
	[qw(DDG::Goodie::HTMLEntities)],
	# Test 1
		'html decode &#33;' => test_zci("Decoded HTML Entity: !, decimal: 33, hexadecimal: 0021", html => "<div>Decoded HTML Entity: &#33;, decimal: 33, hexadecimal: <a href=\"/?q=U%2B0021\">0021</a></div>"),
	# Test 2
		'html decode &amp;' => test_zci("Decoded HTML Entity: &, decimal: 38, hexadecimal: 0026", html => "<div>Decoded HTML Entity: &amp;, decimal: 38, hexadecimal: <a href=\"/?q=U%2B0026\">0026</a></div>"),
	# Test 3
		'&#x21 decode html' => test_zci("Decoded HTML Entity: !, decimal: 33, hexadecimal: 0021", html => "<div>Decoded HTML Entity: &#x21;, decimal: 33, hexadecimal: <a href=\"/?q=U%2B0021\">0021</a></div>"),
	# Test 4 - freedom in input - no & or ;
		'#36 html entity' => test_zci("Decoded HTML Entity: \$, decimal: 36, hexadecimal: 0024", html => "<div>Decoded HTML Entity: &#36;, decimal: 36, hexadecimal: <a href=\"/?q=U%2B0024\">0024</a></div>"),
	# Test 5 - no ending semicolon in input / variety in hex (X)
		'&#X22 decodehtml' => test_zci("Decoded HTML Entity: \", decimal: 34, hexadecimal: 0022", html => "<div>Decoded HTML Entity: &#X22;, decimal: 34, hexadecimal: <a href=\"/?q=U%2B0022\">0022</a></div>"),
	# Test 6 - variety in hex (x)
		'decodehtml #x3c' => test_zci("Decoded HTML Entity: <, decimal: 60, hexadecimal: 003c", html => "<div>Decoded HTML Entity: &#x3c;, decimal: 60, hexadecimal: <a href=\"/?q=U%2B003c\">003c</a></div>"),
);

done_testing;
