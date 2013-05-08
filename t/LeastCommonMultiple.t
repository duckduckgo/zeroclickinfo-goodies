#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "least_common_multiple";
zci is_cached => 1;

ddg_goodie_test(
    [qw(
	DDG::Goodie::LeastCommonMultiple
    )],
	'lcm 12 57' => test_zci('Least common multiple of 12 and 57: 228'),
	'1000 100 least common multiple' => test_zci('Least common multiple of 1000 and 100: 1000'),
	'LCM 19 22' => test_zci('Least common multiple of 19 and 22: 418'),
);

done_testing;
