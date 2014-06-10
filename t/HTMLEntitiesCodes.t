#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'HTML_Entity';

ddg_goodie_test(
	[qw(DDG::Goodie::HTMLEntitiesCodes)],
	# Test 1
	'html reference em dash' => test_zci(
		"Em dash: &mdash;",
		html => "<div>(&mdash;) Em dash: &<span>mdash</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 2
	'html code for middle dot' => test_zci(
		"Middle dot: &middot;",
		html => "<div>(&middot;) Middle dot: &<span>middot</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 3
	'html entity yen' => test_zci(
		"Yen: &yen;",
		html => "<div>(&yen;) Yen: &<span>yen</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 4
	'a acute html entity' => test_zci(
		"a-acute: &aacute;",
		html => "<div>(&aacute;) a-acute: &<span>aacute</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 5
	'pound html code' => test_zci(
		"British Pound Sterling: &pound;\nNumber sign: &#35;",
		html => "<div>(&pound;) British Pound Sterling: &<span>pound</span>;</div><div>(&#35;) Number sign: &<span>#35</span>;</div><div><a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
);

done_testing;
