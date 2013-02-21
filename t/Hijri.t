#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Date:hijri;

zci answer_type => 'date';
zci is_cached => 0;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Hijri
	)],
     'flip a coin' => test_zci(qr/(heads|tails) \(random\)/),
);

done_testing;
