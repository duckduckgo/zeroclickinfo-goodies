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
    'un 9' => test_zci('UN Number 0009 - Ammunition, incendiary with or without burster, expelling charge, or propelling charge.', html => '<a href="http://en.wikipedia.org/wiki/List_of_UN_numbers_0001_to_0100">UN Number 0009</a> - Ammunition, incendiary with or without burster, expelling charge, or propelling charge.', answer_type => "united_nations"),
    'un number 9' => test_zci('UN Number 0009 - Ammunition, incendiary with or without burster, expelling charge, or propelling charge.', html => '<a href="http://en.wikipedia.org/wiki/List_of_UN_numbers_0001_to_0100">UN Number 0009</a> - Ammunition, incendiary with or without burster, expelling charge, or propelling charge.', answer_type => "united_nations"),
    'un 1993'   => test_zci('UN Number 1993 - Combustible liquids, n.o.s.', html => '<a href="http://en.wikipedia.org/wiki/List_of_UN_numbers_1901_to_2000">UN Number 1993</a> - Combustible liquids, n.o.s.', answer_type => "united_nations"),
    'un number foo' => undef,
    'UN Number 0009' => test_zci('UN Number 0009 - Ammunition, incendiary with or without burster, expelling charge, or propelling charge.', html => '<a href="http://en.wikipedia.org/wiki/List_of_UN_numbers_0001_to_0100">UN Number 0009</a> - Ammunition, incendiary with or without burster, expelling charge, or propelling charge.', answer_type => "united_nations"),
);

done_testing;

