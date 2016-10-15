#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'number_sequences';
zci is_cached   => 1;

sub build_structured_answer {
    my ($raw_number, $type, $number, $result) = @_;

    return "$raw_number $type is:",
           structured_answer => {

               data => {
                   title    => "$result",
                   subtitle => "$raw_number $type number"
               },

               templates => {
                   group => 'text',
               }
           };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
        [qw( DDG::Goodie::NumberSequences )],
        '5th prime number' => build_test('5th', 'Prime', '5', '11'),
        '1st prime number' => build_test('1st', 'Prime', '1', '2'),
        '10th prime number' => build_test('10th', 'Prime', '10', '29'),
        '10th number prime' => build_test('10th', 'Prime', '10', '29'),
        '10th prime' => build_test('10th', 'Prime', '10', '29'),
        '1,000th prime number' => build_test('1000th', 'Prime', '1000', '7919'),
        '1,500th prime number' => build_test('1500th', 'Prime', '1500', '12553'),
        '5th catalan number' => build_test('5th', 'Catalan', '5', '42'),
        '5st catalan number' => build_test('5th', 'Catalan', '5', '42'),
        '5th Tetrahedral number' => build_test('5th', 'Tetrahedral', '5', '35'),
        '5st Tetrahedral number' => build_test('5th', 'Tetrahedral', '5', '35'),
        '5th duck number' => undef,
        '10th 10 prime' => undef 
        );

done_testing;
