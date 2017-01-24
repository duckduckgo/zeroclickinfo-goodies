#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'golden_ratio';
zci is_cached => 1;

sub build_structured_answer {
    my ($left_side, $right_side, $input) = @_;

    return "Golden ratio: $left_side:$right_side", structured_answer => {
        data => {
            title => "$left_side:$right_side",
            subtitle => "Golden ratio for $input"
        },
        templates => {
            group => 'text'
        }
    };
}

ddg_goodie_test(
        [qw(
                DDG::Goodie::GoldenRatio
        )],
        'golden ratio 1:?' => test_zci(build_structured_answer('1', '1.61803398874989', '1:?')),
        'golden ratio 2.5:?' => test_zci(build_structured_answer('2.5', '4.04508497187474', '2.5:?')),
        'golden ratio 450:?' => test_zci(build_structured_answer('450', '728.115294937453', '450:?')),
        'golden ratio 900:?' => test_zci(build_structured_answer('900', '1456.23058987491', '900:?')),
        'golden ratio 1024.56:?' => test_zci(build_structured_answer('1024.56', '1657.77290351359', '1024.56:?')),
        'golden ratio ?:900' => test_zci(build_structured_answer('556.230589874905', '900', '?:900')),
        'golden ratio ?:768.5' => test_zci(build_structured_answer('474.959120354294', '768.5', '?:768.5')),
        'golden ratio ?:1680.12345678' => test_zci(build_structured_answer('1038.37340158601', '1680.12345678', '?:1680.12345678')),
        'golden ratio 1 : ?' => test_zci(build_structured_answer('1', '1.61803398874989', '1:?')),
        'golden ratio 1 :?' => test_zci(build_structured_answer('1', '1.61803398874989', '1:?')),
        'golden ratio 1: ?' => test_zci(build_structured_answer('1', '1.61803398874989', '1:?')),
        'golden ratio ? : 9' => test_zci(build_structured_answer('5.56230589874905', '9', '?:9')),
        'golden ratio ? :9' => test_zci(build_structured_answer('5.56230589874905', '9', '?:9')),
        'golden ratio ?: 9' => test_zci(build_structured_answer('5.56230589874905', '9', '?:9')),
        'golden ratio ?:123.345' => test_zci(build_structured_answer('76.2314023423558', '123.345', '?:123.345')),
);

done_testing;
