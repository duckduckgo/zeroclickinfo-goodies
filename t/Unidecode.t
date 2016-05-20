#!/usr/bin/env perl
use utf8;
use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'convert_to_ascii';
zci is_cached => 1;


ddg_goodie_test(
	[qw(
		DDG::Goodie::Unidecode
	)],
	'unidecode møæp'   => test_zci('moaep'),
    "unidecode \x{5317}\x{4EB0}" => test_zci('Bei Jing'),
    'unidecode åäº°' => test_zci('aaodeg'),
);

done_testing;
