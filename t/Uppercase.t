#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'uppercase';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Uppercase
	)],
	'upper case this' => test_zci('THIS'),
	'uppercase that' => test_zci('THAT'),
        'allcaps this string' => test_zci('THIS STRING'),
        'that string all caps' => test_zci('THAT STRING'),
        'is this uppercase, sir?' => undef,
);

done_testing;
