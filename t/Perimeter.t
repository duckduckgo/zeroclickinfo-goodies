#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'perimeter';
zci is_cached => 1;

sub build_answer {
    my ($answer, $shape) = @_;
    $shape = '' unless $shape;
    
    return $answer, structured_answer => {
        id => 'perimeter',
        name => 'Answer',
        data => {
            title => $answer,
            subtitle => ($shape eq 'circle') ? 'Circumference' : 'Perimeter'
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
        'circumference circle 1' => test_zci(build_answer(6.28318530717959, 'circle')),
        'perimeter hexagon 45' => test_zci(build_answer(270)),
        'perimeter of triangle 1.5 2 3.2' => test_zci(build_answer(6.7)),
        "perimeter square 1" => test_zci(build_answer(4)),
        "perimeter square 1.5" => test_zci(build_answer(6)),
        "perimeter of square 1" => test_zci(build_answer(4)),
        "perimeter rectangle 1 2" => test_zci(build_answer(6)),
        "perimeter rectangle 1.5 2" => test_zci(build_answer(7)),
        "perimeter of rectangle 1 2" => test_zci(build_answer(6)),
        "perimeter triangle 1 2 3" => test_zci(build_answer(6)),
        "perimeter of triangle 1 2 3" => test_zci(build_answer(6)),
        "perimeter pentagon 1" => test_zci(build_answer(5)),
        "perimeter pentagon 1.5" => test_zci(build_answer(7.5)),
        "perimeter of pentagon 1" => test_zci(build_answer(5)),
        "perimeter hexagon 1" => test_zci(build_answer(6)),
        "perimeter hexagon 1.5" => test_zci(build_answer(9)),
        "perimeter of hexagon 1" => test_zci(build_answer(6)),
        "perimeter octagon 1" => test_zci(build_answer(8)),
        "perimeter octagon 1.5" => test_zci(build_answer(12)),
        "perimeter of octagon 1" => test_zci(build_answer(8)),
        "perimeter circle 1.5" => test_zci(build_answer(9.42477796076938, 'circle')),
        "perimeter of circle 1" => test_zci(build_answer(6.28318530717959, 'circle')),
        "circumference 1" => test_zci(build_answer(6.28318530717959, 'circle')),
        "circumference 1.5" => test_zci(build_answer(9.42477796076938, 'circle')),
        "circumference of circle 1" => test_zci(build_answer(6.28318530717959, 'circle')),
        'perimeter of square 3' => test_zci(build_answer(12)),
);

done_testing;
