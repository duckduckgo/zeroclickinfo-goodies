#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "paleo_ingredient_check";
zci is_cached   => 1;

sub build_test {
    my ($text, $input) = @_;
    return test_zci($text, structured_answer =>{
        data => {
            title => $text,
            subtitle => "Paleo Friendly: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::PaleoIngredientCheck )],
    'are apples paleo friendly' => build_test('Yes', "apples"),
    'Is dairy allowed on the paleo diet?' => build_test('No', "dairy"),
    'Is sugar paleo friendly?' => build_test("No", "sugar"),
    'beans paleo safe' => build_test("No", "beans"),
    'is sugar paleo' => build_test("No", "sugar"),
    'Is foobar allowed on the paleo diet?' => undef,
    'are notarealfood paleo friendly' => undef,
    'paleo diet recipes' => undef,
    'paleo recipes' => undef,
);

done_testing;
