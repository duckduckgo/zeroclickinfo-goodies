#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'dessert';
zci is_cached => 0;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Dessert
        )],
        'desserts beginning with a'   => test_zci( qr/A dessert beginning with A is (.*)/ ),
        'dessert start with a'   => test_zci( qr/A dessert beginning with A is (.*)/ ),
	'desserts starting with a'   => test_zci( qr/A dessert beginning with A is (.*)/ ),
	'dessert starts with a'   => test_zci( qr/A dessert beginning with A is (.*)/ ),

	'desserts beginning with A'   => test_zci( qr/A dessert beginning with A is (.*)/ ),
	'desserts beginning with z'   => test_zci( qr/A dessert beginning with Z is (.*)/ )
);

done_testing;
