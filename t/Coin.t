#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'coin';
zci is_cached => 0;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Coin
	)],
    'flip a coin' => test_zci(
	qr/(heads|tails) \(random\)/,
	html => qr/(heads|tails) \(random\)/,
    ),
    'flip 1 coin' => test_zci(
	qr/(heads|tails) \(random\)/,
	html => qr/(heads|tails) \(random\)/,
    ),
    'flip 2 coins' => test_zci(
	qr/(heads|tails), (heads|tails) \(random\)/,
	html => qr/(heads|tails) \(random\)/,
    ),
    'toss a coin' => test_zci(
	qr/(heads|tails) \(random\)/,
	html => qr/(heads|tails) \(random\)/,
    ),
    'toss 1 coin' => test_zci(
	qr/(heads|tails) \(random\)/,
	html => qr/(heads|tails) \(random\)/,
    ),
    'toss 2 coins' => test_zci(
	qr/(heads|tails), (heads|tails) \(random\)/,
	html => qr/(heads|tails) \(random\)/,
    ),
    'heads or tails' => test_zci(
	qr/(heads|tails) \(random\)/,
	html => qr/(heads|tails) \(random\)/,
    ),
    'heads or tails?' => test_zci(
	qr/(heads|tails) \(random\)/,
	html => qr/(heads|tails) \(random\)/,
    ),
    'flip 4 coins' => test_zci(
	qr/((heads|tails),? ){4}\(random\)/,
	html => qr/(heads|tails) \(random\)/,
    ),
);

done_testing;
