#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use utf8;

zci answer_type => "area_circle";
zci is_cached   => 1;

sub build_test {
    my ($answer, $input) = @_;
    return test_zci($answer, structured_answer => {
        data => {
            title => $answer,
            subtitle=> "Area of Circle with radius $input"
        },
        templates => {
            group => 'text'
        }
    })
}

ddg_goodie_test(
    [qw( DDG::Goodie::AreaCircle )],

    'area of circle radius 1' => build_test("3.14285714285714",1),
    'area of circle of radius 1' => build_test("3.14285714285714",1),
    'area of circle with radius 1' => build_test("3.14285714285714",1),
    'area of circle in radius 1' => build_test("3.14285714285714",1),

    'area' => undef,
    'circle' => undef,
);

done_testing;
