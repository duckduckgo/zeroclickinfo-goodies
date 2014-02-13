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
     'flip a coin' => test_zci(qr/(heads|tails) \(random\)/),
     'flip 1 coin' => test_zci(qr/(heads|tails) \(random\)/),
     'flip 2 coins' => test_zci(qr/(heads|tails), (heads|tails) \(random\)/),
     'toss a coin' => test_zci(qr/(heads|tails) \(random\)/),
     'toss 1 coin' => test_zci(qr/(heads|tails) \(random\)/),
     'toss 2 coins' => test_zci(qr/(heads|tails), (heads|tails) \(random\)/),
     'heads or tails' => test_zci(qr/(heads|tails) \(random\)/),
     'heads or tails?' => test_zci(qr/(heads|tails) \(random\)/),
     
     # Russian translation
     'орёл или решка' => test_zci(qr/(орёл|решка) \(random\)/),
     'орёл или решка?' => test_zci(qr/(орёл|решка) \(random\)/),
     'орел или решка' => test_zci(qr/(орёл|решка) \(random\)/),
     'орел или решка?' => test_zci(qr/(орёл|решка) \(random\)/),
);

done_testing;
