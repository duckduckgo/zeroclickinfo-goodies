#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "birth_stone";
zci is_cached   => 1;

sub build_structured_answer {
    my ($month, $birthstone) = @_;
    return "$month birthstone: $birthstone",
    structured_answer => {
            data => {
                title    => $birthstone,
                subtitle => "Birthstone for $month",
            },
            templates => {
                group => 'text',
            }
    }
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::BirthStone )],
    'april birth stone'   => build_test('April', 'Diamond'),
    'birthstone JUNE'     => build_test('June', 'Pearl'),
    'DecEmber birthstone' => build_test('December', 'Turquoise'),
    'birthstone april'    => build_test('April', 'Diamond'),
    'may birth stone'     => build_test('May', 'Emerald')
);

done_testing;
