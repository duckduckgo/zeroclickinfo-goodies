#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

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
    '12 digits of π' => test_zci("3.141592653589",
	structured_answer => {
		input => [],
		operation => ["First 12 digits of Pi"],
		result => "3.141592653589"
	}),
    'pi to 6 digits' => test_zci("3.141592",
	structured_answer => {
		input => [],
		operation => ["First 6 digits of Pi"],
		result => "3.141592"
	}),
    'π to 6 digits' => test_zci("3.141592",
	structured_answer => {
		input => [],
		operation => ["First 6 digits of Pi"],
		result => "3.141592"
	}),

	'pi ff' => undef,
	'pi 3f2' => undef

);

done_testing;
