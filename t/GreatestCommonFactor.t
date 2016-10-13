#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "greatest_common_factor";
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my ($numbers, $result) = @_;

    return "Greatest common factor of $numbers is $result",
        structured_answer => {
            data => {
                title    => $result,
                subtitle => "Greatest common factor: $numbers"
            },
            templates => {
                group => "text"
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::GreatestCommonFactor )],
    'gcf 9 81'                        => build_test('9 and 81', 9),
    '1000 100 greatest common factor' => build_test('100 and 1000', 100),
    'GCF 12 76'                       => build_test('12 and 76', 4),
    'GCF 121 11'                      => build_test('11 and 121', 11),
    '99 9 greatest common factor'     => build_test('9 and 99', 9),
    'greatest common divisor 4 6'     => build_test('4 and 6', 2),
    'gcd 4 6'                         => build_test('4 and 6', 2),
    'gcd 12 18 24'                    => build_test('12, 18 and 24', 6),
    'gcd 25 20 15 10 5'               => build_test('5, 10, 15, 20 and 25', 5),
    'gcd 6, 9, ,,,,     12       15'  => build_test('6, 9, 12 and 15', 3),
    'gcd 2 3'                         => build_test('2 and 3', 1),
    'gcd 2 3 5'                       => build_test('2, 3 and 5', 1),
    'gcd 0 2'                         => build_test('0 and 2', 2),
    'gcd 0 0'                         => build_test('0 and 0', 0),
    
    #Tests that should fail
    'gcd 2'                           => undef,
    'gcf 2'                           => undef,
);

done_testing;
