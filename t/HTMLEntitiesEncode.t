#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'html_entity';

ddg_goodie_test(
	[qw(DDG::Goodie::HTMLEntitiesEncode)],
	# Test 1
		'html code em dash' => test_zci(
		"Em dash: &mdash;",
		html => "<div>Em dash (&mdash;): &<span>mdash</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 2
		'html entity A-acute' => test_zci(
		"A-acute: &Aacute;",
		html => "<div>A-acute (&Aacute;): &<span>Aacute</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 3
		'html encode &' => test_zci(
		"Encoded HTML Entity: &amp;",
		html => "<div>Encoded HTML Entity (&amp;): &<span>amp</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 4
		'html code em-dash' => test_zci(
		"Em dash: &mdash;",
		html => "<div>Em dash (&mdash;): &<span>mdash</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 5
		'html entity for E grave' => test_zci(
		"E-grave: &Egrave;",
		html => "<div>E-grave (&Egrave;): &<span>Egrave</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 6
		'html encode $' => test_zci(
		"Encoded HTML Entity: &#36;",
		html => "<div>Encoded HTML Entity (&#36;): &<span>#36</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 7
		'html encode pound symbol' => test_zci(
		"British Pound Sterling: &pound;\nNumber sign: &#35;",
		html => "<div>British Pound Sterling (&pound;): &<span>pound</span>;</div><div>Number sign (&#35;): &<span>#35</span>;</div><div><a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 8
		'html character code for trademark sign' => test_zci(
		"Trademark: &#8482;",
		html => "<div>Trademark (&#8482;): &<span>#8482</span>;&nbsp;&nbsp;<a href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
);

done_testing;
