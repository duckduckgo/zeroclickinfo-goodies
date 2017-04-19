use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'sum';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Sum
	)],
	'sum 1-100' => test_zci("Sum from natural number 1 to 100 is = 5050", html => qr/Sum/),
	'sum from 1 to 10' => test_zci("Sum from natural number 1 to 10 is = 55", html => qr/Sum/),
	'sum 10 to 1000' => test_zci("Sum from natural number 10 to 1000 is = 500455", html => qr/Sum/),
    
);

done_testing;
