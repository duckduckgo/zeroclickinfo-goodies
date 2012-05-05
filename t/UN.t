#!/usr/bin/env perl
use utf8;
use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'un';
zci is_cached => 1;


ddg_goodie_test(
	[qw(
		DDG::Goodie::UN
	)],
    'un 9' => test_zci('UN Number 0009: Ammunition, incendiary with or without burster, expelling charge, or propelling charge (http://en.wikipedia.org/wiki/List_of_UN_numbers_0001_to_0100)'),
	'un 1993'   => test_zci('UN Number 1993: Combustible liquids, n.o.s. (http://en.wikipedia.org/wiki/List_of_UN_numbers_1901_to_2000)'),

);

done_testing;

