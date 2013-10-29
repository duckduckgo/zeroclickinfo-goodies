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
        'desserts beginning with a'   => test_zci( qr/(.*?) is a dessert that begins with the letter A.$/ ),
        'dessert start with a'   => test_zci( qr/(.*?) is a dessert that begins with the letter A.$/ ),
	'desserts starting with a'   => test_zci( qr/(.*?) is a dessert that begins with the letter A$./ ),
	'dessert starts with a'   => test_zci( qr/(.*?) is a dessert that begins with the letter A.$/ ),

	'desserts beginning with A'   => test_zci( qr/(.*?) is a dessert that begins with the letter A.$/ ),
	'desserts beginning with z'   => test_zci( qr/(.*?) is a dessert that begins with the letter Z.$/ ),
        'a dessert that begins with the letter a' => test_zci( qr/(.*?) is a dessert that begins with the letter A.$/ ),
);

done_testing;
