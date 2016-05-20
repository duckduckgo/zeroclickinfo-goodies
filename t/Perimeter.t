#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'perimeter';
zci is_cached => 1;

sub build_answer {
    my ($answer, $shape, $input) = @_;
    
    return $answer, structured_answer => {
        data => {
            title => $answer,
            subtitle => ($shape eq 'circle') ? "Circumference of $shape with radius of $input" : "Perimeter of $shape with sides of $input"
        },
        templates => {
            group => 'text',
            moreAt => 0
        }
    }
}

ddg_goodie_test(
        [qw(
                DDG::Goodie::Perimeter
        )],
        'circumference circle 1' => test_zci(build_answer(6.28318530717959, 'circle', 1)),
        'perimeter hexagon 45' => test_zci(build_answer(270, 'hexagon', 45)),
        'perimeter of triangle 1.5 2 3.2' => test_zci(build_answer(6.7, 'triangle', '1.5, 2 and 3.2')),
        "perimeter square 1" => test_zci(build_answer(4, 'square', 1)),
        "perimeter square 1.5" => test_zci(build_answer(6, 'square', 1.5)),
        "perimeter of square 1" => test_zci(build_answer(4, 'square', 1)),
        "perimeter rectangle 1 2" => test_zci(build_answer(6, 'rectangle', '1 and 2')),
        "perimeter rectangle 1.5 2" => test_zci(build_answer(7, 'rectangle', '1.5 and 2')),
        "perimeter of rectangle 1 2" => test_zci(build_answer(6, 'rectangle', '1 and 2')),
        "perimeter triangle 1 2 3" => test_zci(build_answer(6, 'triangle', '1, 2 and 3')),
        "perimeter of triangle 1 2 3" => test_zci(build_answer(6, 'triangle', '1, 2 and 3')),
        "perimeter pentagon 1" => test_zci(build_answer(5, 'pentagon', 1)),
        "perimeter pentagon 1.5" => test_zci(build_answer(7.5, 'pentagon', 1.5)),
        "perimeter of pentagon 1" => test_zci(build_answer(5, 'pentagon', 1)),
        "perimeter hexagon 1" => test_zci(build_answer(6, 'hexagon', 1)),
        "perimeter hexagon 1.5" => test_zci(build_answer(9, 'hexagon', 1.5)),
        "perimeter of hexagon 1" => test_zci(build_answer(6, 'hexagon', 1)),
        "perimeter octagon 1" => test_zci(build_answer(8, 'octagon', 1)),
        "perimeter octagon 1.5" => test_zci(build_answer(12, 'octagon', 1.5)),
        "perimeter of octagon 1" => test_zci(build_answer(8, 'octagon', 1)),
        "perimeter circle 1.5" => test_zci(build_answer(9.42477796076938, 'circle', 1.5)),
        "perimeter of circle 1" => test_zci(build_answer(6.28318530717959, 'circle', 1)),
        "circumference 1" => test_zci(build_answer(6.28318530717959, 'circle', 1)),
        "circumference 1.5" => test_zci(build_answer(9.42477796076938, 'circle', 1.5)),
        "circumference of circle 1" => test_zci(build_answer(6.28318530717959, 'circle', 1)),
        'perimeter of square 3' => test_zci(build_answer(12, 'square', 3)),
);

done_testing;
