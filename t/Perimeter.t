#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'perimeter';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Perimeter
        )],
        'circumference circle 1' => test_zci('Circumference: 6.28318530717959'),
        'perimeter hexagon 45' => test_zci('Perimeter of hexagon: 270'),
        'perimeter of triangle 1.5 2 3.2' => test_zci('Perimeter of triangle: 6.7'),
);

done_testing;
