#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'conversion';
zci is_cached   => 1;

ddg_goodie_test(
	[qw( DDG::Goodie::HexToDec )],
	'0xd1038d2e07b42569' => test_zci(
        'd1038d2e07b42569 base 16 = 15061036807694329193 base 10 == 1504034322700755022551 base 8 == 1101000100000011100011010010111000000111101101000010010101101001 base 2',
        html => "<style type='text/css'>.zci--answer .zci--conversions {
    font-size: 1.5em;
    font-weight: 300;
    padding-top: .25em;
    padding-bottom: .25em;
}</style><div class='zci--conversions text--primary'>15061036807694329193 <sub>10</sub><div style='font-size:75%'><span class='text--secondary'>Binary: </span> 1101000100000011100011010010111000000111101101000010010101101001 <span class='text--secondary'>Octal: </span> 1504034322700755022551</div>"),
	'0x44696f21' => test_zci(
        '44696f21 base 16 = 1147760417 base 10 == 10432267441 base 8 == 1000100011010010110111100100001 base 2',
        html => "<style type='text/css'>.zci--answer .zci--conversions {
    font-size: 1.5em;
    font-weight: 300;
    padding-top: .25em;
    padding-bottom: .25em;
}</style><div class='zci--conversions text--primary'>1147760417 <sub>10</sub><div style='font-size:75%'><span class='text--secondary'>Binary: </span> 1000100011010010110111100100001 <span class='text--secondary'>Octal: </span> 10432267441</div>"),
    '0x44696f2Z' => undef,
);

done_testing;

