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
    'rc4 en mysecretkey hello' => test_zci("RC4 Encrypt: hello, with key: mysecretkey is grYU1K8=",
	structured_answer => {
		input => ['hello, Key: mysecretkey'],
		operation => "RC4 Encrypt",
		result => "grYU1K8="
	}),
	'rc4 de duck yWrJniG/nNg=' => test_zci("RC4 Decrypt: yWrJniG/nNg=, with key: duck is DdgRocks",
	structured_answer => {
		input => ['yWrJniG/nNg=, Key: duck'],
		operation => "RC4 Decrypt",
		result => "DdgRocks"
	}),
    'rc4 ' => undef,
    'rc4 enc missing' => undef,
    'rc4 no operation' => undef
);

done_testing;
