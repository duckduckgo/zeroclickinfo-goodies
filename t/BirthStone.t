#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "BirthStone";
zci is_cached => 1;

ddg_goodie_test(
    [qw(
	DDG::Goodie::BirthStone
    )],
	'april birth stone' => test_zci('April birthstone: Diamond'),
	'birthstone JUNE' => test_zci('June birthstone: Pearl'),
	'DecEmber birthstone' => test_zci('December birthstone: Turquoise'),
    'birthstone april' => test_zci('April birthstone: Diamond'),
    'may birth stone' => test_zci('May birthstone: Emerald'),
);

done_testing;
