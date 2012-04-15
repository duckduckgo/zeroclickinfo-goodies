#!/usr/bin/env perl
use utf8;
use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'convert to ascii';
zci is_cached => 1;


ddg_goodie_test(
	[qw(
		DDG::Goodie::Unidecode
	)],
	'unidecode møæp'   => test_zci('moaep'),
    "unidecode \x{5317}\x{4EB0}" => test_zci('Bei Jing'),

);

done_testing;

