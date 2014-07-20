#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'geometry';

ddg_goodie_test(
	['DDG::Goodie::Geometry'],
	'formula circle perimeter' => test_zci('u = 2'.chr(960).'r', html => qr#u = 2&pi;r#s),
	'calc circle area with radius = 3' => test_zci('A = '.chr(960).'r'.chr(178).' = 28.2743338823081', html => qr#A = &pi;r<sup>2</sup> = 28.2743338823081#s),
	'geometry cube volume length 50.6' => test_zci('V = a'.chr(179).' = 129554.216', html => qr#V = a<sup>3</sup> = 129554.216#s),
	'calc equilateral triangle perimeter' => test_zci('u = 3a', html => qr#u = 3a#s),
	'formula ball volume' => test_zci('V = 4/3'.chr(960).'r'.chr(179), html => qr#V = 4/3&pi;r<sup>3</sup>#s),
	'geometry rectangle area a = 5,2, b = 10' => test_zci('A = ab = 52', html => qr#A = ab = 52#s),
	'geometry cuboid volume a: 5; b: 3; c: 4' => test_zci('V = abc = 60', html => qr#V = abc = 60#s)
);

done_testing;
