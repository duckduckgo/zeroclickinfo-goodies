#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'isvalid';
zci is_cached   => 1;

ddg_goodie_test(
	[qw(DDG::Goodie::IsValid::JSON)],
	'is valid json {"test":"lol"}' => test_zci(
		'Your JSON is valid!',
		html => 'Your JSON is valid!'
	),
	'is valid json {"test" "lol"}' => test_zci(
		'Your JSON is invalid: \':\' expected, at character offset 8 (before ""lol"}")',
		html => 'Your JSON is invalid: <pre style="font-size:12px;margin-top:5px;">\':\' expected, at character offset 8 (before ""lol"}")</pre>'
	)
);

done_testing;
