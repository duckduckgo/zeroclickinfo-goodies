#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use DDG::Test::Goodie;

zci answer_type => 'math';
zci is_cached => 1;

use_ok('DDG::Goodie::Math');

ddg_goodie_test(
	[qw(
		DDG::Goodie::Math
	)],
	'$\sum_{i=0}^{N} x_i$' => test_zci('', html => qr|<span class="math">\$\\sum_{i=0}\^{N} x_i\$</span>|),
	'$$\sum_{i=0}^{N} x_i$$' => test_zci('', html => qr|<span class="math">\$\$\\sum_{i=0}\^{N} x_i\$\$</span>|),
	'\(\sum_{i=0}^{N} x_i\)' => test_zci('', html => qr|<span class="math">\\\(\\sum_{i=0}\^{N} x_i\\\)</span>|),
	'\[\sum_{i=0}^{N} x_i\]' => test_zci('', html => qr|<span class="math">\\\[\\sum_{i=0}\^{N} x_i\\\]</span>|),
);

done_testing;
