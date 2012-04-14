#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'aspect_ratio';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::AspectRatio
	)],
	'aspect ratio 4:3 640:?' => test_zci('Aspect ratio 4:3 -> 640:480'),
	'aspect ratio 4:3 ?:480' => test_zci('Aspect ratio 4:3 -> 640:480'),
);

done_testing;
