#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'dessert';
zci is_cached => 0;

ddg_goodie_test(
	[
		'DDG::Goodie::Dessert'
	],
    'desserts beginning with a' => test_zci(
	qr/(.*?) is a dessert that begins with 'a'\.$/,
	html => qr/(.*?) is a dessert that begins with 'a'\.$/
    ),
    'desserts beginning with A' => test_zci(
	qr/(.*?) is a dessert that begins with 'A'\.$/,
	html => qr/(.*?) is a dessert that begins with 'A'\.$/
    ),
    'dessert start with a' => test_zci(
	qr/(.*?) is a dessert that begins with 'a'\.$/,
	html => qr/(.*?) is a dessert that begins with 'a'\.$/
    ),
    'desserts starting with a' => test_zci(
	qr/(.*?) is a dessert that begins with 'a'\.$/,
	html => qr/(.*?) is a dessert that begins with 'a'\.$/
    ),
    'dessert starts with a' => test_zci(
	qr/(.*?) is a dessert that begins with 'a'\.$/,
	html => qr/(.*?) is a dessert that begins with 'a'\.$/
    ),
    'desserts beginning with z' => test_zci(
	qr/(.*?) is a dessert that begins with 'z'\.$/,
	html => qr/(.*?) is a dessert that begins with 'z'\.$/
    ),
    'a dessert that begins with a' => test_zci(
	qr/(.*?) is a dessert that begins with 'a'\.$/,
	html => qr/(.*?) is a dessert that begins with 'a'\.$/
    ),
    'a dessert that starts with the letter a' => test_zci(
    qr/(.*?) is a dessert that begins with 'a'\.$/,
    html => qr/(.*?) is a dessert that begins with 'a'\.$/
    ),
    'dessert that begins with the letter z' => test_zci(
    qr/(.*?) is a dessert that begins with 'z'\.$/,
    html => qr/(.*?) is a dessert that begins with 'z'\.$/
    ),
);

done_testing;
