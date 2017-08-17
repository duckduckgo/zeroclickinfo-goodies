#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'ceramic_capacitor_codes';
zci is_cached   => 1;

sub build_test {
    my ($answer, $input) = @_;
    return test_zci($answer,
    structured_answer => {
        data => {
            title => $answer,
            subtitle => "Decode Ceramic Capacitor: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::CeramicCapacitorCodes )],
    'decode ceramic capacitor 103k' => build_test("10 nF ±10%", "103K"),
    'ceramic capacitor 102C' => build_test("1 nF ±0.25pF", "102C"),
    'ceramic capacitor 333J' => build_test("33 nF ±5%", "333J"),
    'ceramic capacitor 476M' => build_test("47 μF ±20%", "476M"),
    'ceramic capacitor 101d' => build_test("100 pF ±0.5pF", "101D"),
    'ceramic capacitor 104Z' => build_test("100 nF +80% / -20%", "104Z"),
    'ceramic capacitor 105' => build_test('1 μF', '105'),
    'ceramic capacitor 103' => build_test('10 nF', '103'),
    'ceramic capacitor 101' => build_test('100 pF', '101'),
    'ceramic capacitor 330' => build_test('33 pF', '330'),
    '103 ceramic capacitor' => build_test('10 nF', '103'),
    '103 capacitor' => build_test('10 nF', '103'),
    'ceramic capacitor' => undef,
    'buy ceramic capacitors' => undef,
);

done_testing;
