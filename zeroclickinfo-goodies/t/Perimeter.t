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
        "perimeter square 1" => test_zci("Perimeter of square: 4"),
        "perimeter square 1.5" => test_zci("Perimeter of square: 6"),
        "perimeter of square 1" => test_zci("Perimeter of square: 4"),
        "perimeter rectangle 1 2" => test_zci("Perimeter of rectangle: 6"),
        "perimeter rectangle 1.5 2" => test_zci("Perimeter of rectangle: 7"),
        "perimeter of rectangle 1 2" => test_zci("Perimeter of rectangle: 6"),
        "perimeter triangle 1 2 3" => test_zci("Perimeter of triangle: 6"),
        "perimeter of triangle 1 2 3" => test_zci("Perimeter of triangle: 6"),
        "perimeter pentagon 1" => test_zci("Perimeter of pentagon: 5"),
        "perimeter pentagon 1.5" => test_zci("Perimeter of pentagon: 7.5"),
        "perimeter of pentagon 1" => test_zci("Perimeter of pentagon: 5"),
        "perimeter hexagon 1" => test_zci("Perimeter of hexagon: 6"),
        "perimeter hexagon 1.5" => test_zci("Perimeter of hexagon: 9"),
        "perimeter of hexagon 1" => test_zci("Perimeter of hexagon: 6"),
        "perimeter octagon 1" => test_zci("Perimeter of octagon: 8"),
        "perimeter octagon 1.5" => test_zci("Perimeter of octagon: 12"),
        "perimeter of octagon 1" => test_zci("Perimeter of octagon: 8"),
        "perimeter circle 1.5" => test_zci("Circumference: 9.42477796076938"),
        "perimeter of circle 1" => test_zci("Circumference: 6.28318530717959"),
        "circumference 1" => test_zci("Circumference: 6.28318530717959"),
        "circumference 1.5" => test_zci("Circumference: 9.42477796076938"),
        "circumference of circle 1" => test_zci("Circumference: 6.28318530717959"),
        'perimeter of square 3' => test_zci('Perimeter of square: 12'),
);

done_testing;
