#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 2048;
zci is_cached   => 1;


ddg_goodie_test(
    [qw( DDG::Goodie::2048 )],

    'play 2048' => test_zci(
		'Play 2048', html => qr/(.+)/
	),
	'play 256 7' => test_zci(
		'Play 256 7', html => qr/(.+)/
    ),
    '2048 online' => undef
);

done_testing;
