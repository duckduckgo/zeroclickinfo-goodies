#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'average';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Average
	)],
	'1 2 3 avg' => test_zci("Mean: 2; Median: 2; Root Mean Square: 2.16024689946929", html => qr/Mean:/),
	'mean 1, 2, 3' => test_zci("Mean: 2; Median: 2; Root Mean Square: 2.16024689946929", html => qr/Mean:/),
	'root mean square 1,2,3' => test_zci("Mean: 2; Median: 2; Root Mean Square: 2.16024689946929", html => qr/Mean:/),
    "average 12 45 78 1234.12" => test_zci("Mean: 342.28; Median: 61.5; Root Mean Square: 618.72958034993", html => qr/Mean:/),
    "average 12, 45, 78, 1234.12" => test_zci("Mean: 342.28; Median: 61.5; Root Mean Square: 618.72958034993", html => qr/Mean:/),
    "average 12;45;78;1234.12" => test_zci("Mean: 342.28; Median: 61.5; Root Mean Square: 618.72958034993", html => qr/Mean:/),
    'average 12, 45, 78, 1234' => test_zci('Mean: 342.25; Median: 61.5; Root Mean Square: 618.669742269654', html => qr/Mean:/),
    'avg 1,2,3' => test_zci('Mean: 2; Median: 2; Root Mean Square: 2.16024689946929', html => qr/Mean:/),
);

done_testing;

