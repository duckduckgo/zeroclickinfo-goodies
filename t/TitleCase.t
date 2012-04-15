#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'title_case';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::TitleCase
	)],
	'titlecase test this out' => test_zci('Test This Out'),
);

done_testing;
