#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'HTML_Entity';

ddg_goodie_test(
	[qw(DDG::Goodie::HTMLEntitiesCodes)],
	# Test 1
		'html code em dash' => test_zci(
		"Em dash: &mdash;",
		html => "<div>(&mdash;) Em dash: &<span>mdash</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 2
		'html entity A-acute' => test_zci(
		"A-acute: &Aacute;",
		html => "<div>(&Aacute;) A-acute: &<span>Aacute</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 3
		'html encode backward semicolon' => test_zci(
		"Backward semicolon: &#8271;",
		html => "<div>(&#8271;) Backward semicolon: &<span>#8271</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 4
		'html entity for E grave' => test_zci(
		"E-grave: &Egrave;",
		html => "<div>(&Egrave;) E-grave: &<span>Egrave</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 5
		'html encode pound symbol' => test_zci(
		"British Pound Sterling: &pound;\nNumber sign: &#35;",
		html => "<div>(&pound;) British Pound Sterling: &<span>pound</span>;</div><div>(&#35;) Number sign: &<span>#35</span>;</div><div><a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 6
		'html code of trademark sign' => test_zci(
		"Trademark: &#8482;",
		html => "<div>(&#8482;) Trademark: &<span>#8482</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
);

done_testing;
