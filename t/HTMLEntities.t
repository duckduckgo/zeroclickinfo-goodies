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
	'&#33;' => test_zci("Decoded HTML Entity: !, decimal: 33"),
	'&#x21' => test_zci("Decoded HTML Entity: !, decimal: 33"),
	'html entity &amp;' => test_zci("Decoded HTML Entity: &, decimal: 38"),
);

done_testing;

