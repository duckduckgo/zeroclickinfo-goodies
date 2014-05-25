#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use lib '/home/pixel/perl5/lib/perl5/';
use lib '/home/pixel/zeroclickinfo-goodies/lib/';
use DDG::Test::Goodie;

zci answer_type => 'geometry';

ddg_goodie_test(
 ['DDG::Goodie::Geometry'],
 'formula circle perimeter' => test_zci('u = 2'.chr(960).'r'),
 'calc circle area with radius = 3' => test_zci('A = 28.2743338823081'),
 'geometry cube volume length 50.6' => test_zci('V = 129554.216'),
 'calc equilateral triangle perimeter' => test_zci('u = 3a'),
 'formula ball volume' => test_zci('V = 4/3'.chr(960).'r'.chr(179)),
 'geometry rectangle area a = 5,2, b = 10' => test_zci('A = 52'),
 'geometry cuboid volume a: 5; b: 3; c: 4' => test_zci('V = 60')
);

done_testing;
