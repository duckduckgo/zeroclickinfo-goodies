#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

ddg_goodie_test(
	[qw(
		DDG::Goodie::<: $ia_name :>
	)],
	'example query' => test_zci('query')
);

done_testing;
