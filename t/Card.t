#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'card';
zci is_cached => 0;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Card
	)],
     'pick a card' => test_zci(qr/(\d|ace|jack|queen|king) of (clubs|spades|diamonds|hearts)  \(random\)/),
     'pick 1 card' => test_zci(qr/(\d|ace|jack|queen|king) of (clubs|spades|diamonds|hearts)  \(random\)/),
     'pick 2 cards' => test_zci(qr/(\d|ace|jack|queen|king) of (clubs|spades|diamonds|hearts)  (\d|ace|jack|queen|king) of (clubs|spades|diamonds|hearts)  \(random\)/),
#     'choose a card' => test_zci(qr/(\d|ace|jack|queen|king) of (clubs|spades|diamonds|hearts)  \(random\)/),
#     'choose 1 card' => test_zci(qr/(\d|ace|jack|queen|king) of (clubs|spades|diamonds|hearts)  \(random\)/),
#     'choose 2 cards' => test_zci(qr/(\d|ace|jack|queen|king) of (clubs|spades|diamonds|hearts)  (\d|ace|jack|queen|king) of (clubs|spades|diamonds|hearts)  \(random\)/),

);

done_testing;
