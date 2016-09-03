#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "bitsum";
zci is_cached   => 1;

sub build_structured_answer {
    my ($input_number, $result) = @_;
    return $result,
        structured_answer => {
            data => {
                title => $result,
                subtitle => "Hamming Weight Calculation: $input_number"
            },
            templates => {
                group => 'text'
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Bitsum )],
    'bitsum 127'            => build_test('127 (Base 10, Decimal)', '7'),
    'bitsum of 127'         => build_test('127 (Base 10, Decimal)', '7'),
    'bitsum 0b1111111'      => build_test('0b1111111 (Base 2, Binary)', '7'),
    'bitsum for 0x1234'     => build_test('0x1234 (Base 16, Hexadecimal)', '5'), 
    'hammingweight 1024'    => build_test('1024 (Base 10, Decimal)', '1'),
    'hammingweight 0b10101' => build_test('0b10101 (Base 2, Binary)', '3'),
    'hw 0xff'               => build_test('0xff (Base 16, Hexadecimal)', '8'),
    'hw for 0xaa'           => build_test('0xaa (Base 16, Hexadecimal)', '4'),
    'hw for 0b11'           => build_test('0b11 (Base 2, Binary)', '2'),
    # Long number tests
    'hw 123456789123456789123456789'          => build_test('123456789123456789123456789 (Base 10, Decimal)', '50'),
    'bitsum 0x123456789ABCDEF123456789ABCDEF' => build_test('0x123456789ABCDEF123456789ABCDEF (Base 16, Hexadecimal)', '64'),
    # Tests which should fail
    'bitsum 213f3a', undef,
    'hw 0d23238', undef,
    'bitsum 0x' => undef,
    'bitsum test' => undef,
    'bitsum 0b' => undef,
);

done_testing;
