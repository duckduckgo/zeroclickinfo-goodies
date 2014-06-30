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
        'd1038d2e07b42569 base 16 = 15061036807694329193 base 10',
        html => "<style type='text/css'>.zci--answer .zci--conversions {
    font-size: 1.5em;
    font-weight: 300;
    padding-top: .25em;
    padding-bottom: .25em;
}</style><div class='zci--conversions text--primary'>d1038d2e07b42569 <sub>16</sub> = 15061036807694329193 <sub>10</sub></div>"),
	'0x44696f21' => test_zci(
        '44696f21 base 16 = 1147760417 base 10',
        html => "<style type='text/css'>.zci--answer .zci--conversions {
    font-size: 1.5em;
    font-weight: 300;
    padding-top: .25em;
    padding-bottom: .25em;
}</style><div class='zci--conversions text--primary'>44696f21 <sub>16</sub> = 1147760417 <sub>10</sub></div>"),
    '0x44696f2Z' => undef,
);

done_testing;

