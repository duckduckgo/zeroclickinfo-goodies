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
		html => "<div>Em dash (&mdash;): &<span>mdash</span>;&nbsp;&nbsp;<a class=\"zci__more-at\" href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 2 - querying accented chars
		'html entity A-acute' => test_zci(
		"A-acute: &Aacute;",
		html => "<div>A-acute (&Aacute;): &<span>Aacute</span>;&nbsp;&nbsp;<a class=\"zci__more-at\" href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 3
		'html encode &' => test_zci(
		"Encoded HTML Entity: &amp;",
		html => "<div>Encoded HTML Entity: &<span>amp</span>;&nbsp;&nbsp;<a class=\"zci__more-at\" href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 4 - hyphens in between don't matter
		'html code em-dash' => test_zci(
		"Em dash: &mdash;",
		html => "<div>Em dash (&mdash;): &<span>mdash</span>;&nbsp;&nbsp;<a class=\"zci__more-at\" href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 5 - variety in querying accented chars
		'html entity for E grave' => test_zci(
		"E-grave: &Egrave;",
		html => "<div>E-grave (&Egrave;): &<span>Egrave</span>;&nbsp;&nbsp;<a class=\"zci__more-at\" href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 6
		'html encode $' => test_zci(
		"Encoded HTML Entity: &#36;",
		html => "<div>Encoded HTML Entity: &<span>#36</span>;&nbsp;&nbsp;<a class=\"zci__more-at\" href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 7 - two entities returned
		'html encode pound symbol' => test_zci(
		"British Pound Sterling: &pound;\nNumber sign: &#35;",
		html => "<div>British Pound Sterling (&pound;): &<span>pound</span>;</div><div>Number sign (&#35;): &<span>#35</span>;</div><div><a class=\"zci__more-at\" href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 8 - extra words like 'for' and 'sign' can be typed in, and are taken care of in the code / new trigger
		'htmlencode pilcrow sign' => test_zci(
		"Pilcrow: &#182;",
		html => "<div>Pilcrow (&#182;): &<span>#182</span>;&nbsp;&nbsp;<a class=\"zci__more-at\" href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 9 - new trigger
		'html escape greater than symbol' => test_zci(
		"Greater than: &gt;",
		html => "<div>Greater than (&gt;): &<span>gt</span>;&nbsp;&nbsp;<a class=\"zci__more-at\" href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 10 - handling too much space / new trigger
		'space   encodehtml' => test_zci(
		"Non-breaking space: &nbsp;",
		html => "<div>Non-breaking space (&nbsp;): &<span>nbsp</span>;&nbsp;&nbsp;<a class=\"zci__more-at\" href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
	# Test 11 - standardized output / new trigger
		'ApoSTrophe escapehtml' => test_zci(
		"Apostrophe: &#39;",
		html => "<div>Apostrophe (&#39;): &<span>#39</span>;&nbsp;&nbsp;<a class=\"zci__more-at\" href=\"http://dev.w3.org/html5/html-author/charref\">More at W3</a></div>",
	),
);

done_testing;
