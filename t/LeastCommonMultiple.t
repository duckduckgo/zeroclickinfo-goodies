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
	'lcm 12 57' => test_zci('Least common multiple of 12 and 57 is 228.', html => 'Least common multiple of 12 and 57 is 228. More at <a href="https://en.wikipedia.org/wiki/Least_common_multiple">Wikipedia</a>.'),
	'1000 100 least common multiple' => test_zci('Least common multiple of 1000 and 100 is 1000.', html => 'Least common multiple of 1000 and 100 is 1000. More at <a href="https://en.wikipedia.org/wiki/Least_common_multiple">Wikipedia</a>.'),
	'LCM 19 22' => test_zci('Least common multiple of 19 and 22 is 418.', html => 'Least common multiple of 19 and 22 is 418. More at <a href="https://en.wikipedia.org/wiki/Least_common_multiple">Wikipedia</a>.'),

);

done_testing;
