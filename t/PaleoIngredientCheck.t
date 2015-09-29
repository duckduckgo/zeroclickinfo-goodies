#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "paleo_ingredient_check";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::PaleoIngredientCheck )],
    'are apples paleo friendly' => test_zci('Yes'),
    'Is dairy allowed on the paleo diet?' => test_zci('No'),
    'Is sugar paleo friendly?' => test_zci('No'),
    'beans paleo safe' => test_zci('No'),
    'is sugar paleo' => test_zci('No'),
    'Is foobar allowed on the paleo diet?' => undef,
    'are notarealfood paleo friendly' => undef,
    'paleo diet recipes' => undef,
    'paleo recipes' => undef,
);

done_testing;