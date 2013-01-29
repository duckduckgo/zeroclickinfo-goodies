#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'paper';
zci is_cached => 0;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Paper
	)],
     'a0 paper size' => test_zci('841mm x 1189mm  33.11in x 46.81in'),
     'c10 paper dimension' => test_zci('28mm x 40mm  1.10in x 1.57in'),
     'b10 paper dimensions' => test_zci('31mm x 44mm  1.22in x 1.73in'),
);

done_testing;

