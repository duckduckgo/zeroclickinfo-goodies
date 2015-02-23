#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "rc4";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::Rc4
    )],
    'rc4 en mysecretkey hello' => test_zci("grYU1K8=",
	structured_answer => {
		input => [],
		operation => "Rc4 Encryption",
		result => "grYU1K8="
	}),
	'rc4 de duck yWrJniG/nNg=' => test_zci("DdgRocks",
	structured_answer => {
		input => [],
		operation => "Rc4 Decryption",
		result => "DdgRocks"
	}),
    'rc4 ' => undef,
    'rc4 enc missing' => undef,
    'rc4 no operation' => undef
);

done_testing;
