#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "pi";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Pi )],

	'pi 23' => test_zci("3.14159265358979323846264",
	structured_answer => {
		input => [],
		operation => ["First 23 digits of Pi"],
		result => "3.14159265358979323846264"
	}),
	'π 8' => test_zci("3.14159265",
	structured_answer => {
		input => [],
		operation => ["First 8 digits of Pi"],
		result => "3.14159265"
	}),
	'12 digits of pi' => test_zci("3.141592653589",
	structured_answer => {
		input => [],
		operation => ["First 12 digits of Pi"],
		result => "3.141592653589"
	}),

	'pi ff' => undef

);

done_testing;
