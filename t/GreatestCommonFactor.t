#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "greatest_common_factor";
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_answer {
    my ($numbers, $result) = @_;

    return "Greatest common factor of $numbers is $result.",
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

ddg_goodie_test(
    [qw( DDG::Goodie::GreatestCommonFactor )],
    'gcf 9 81' 				=> test_zci(build_answer('9 and 81', 9)),
    '1000 100 greatest common factor' 	=> test_zci(build_answer('100 and 1000', 100)),
    'GCF 12 76' 			=> test_zci(build_answer('12 and 76', 4)),
    'GCF 121 11' 			=> test_zci(build_answer('11 and 121', 11)),
    '99 9 greatest common factor' 	=> test_zci(build_answer('9 and 99', 9)),
    'greatest common divisor 4 6' 	=> test_zci(build_answer('4 and 6', 2)),
    'gcd 4 6' 				=> test_zci(build_answer('4 and 6', 2)),
    'gcd 2' 				=> test_zci(build_answer('2', 2)),
    'gcd 12 18 24' 			=> test_zci(build_answer('12, 18 and 24', 6)),
    'gcd 25 20 15 10 5' 		=> test_zci(build_answer('5, 10, 15, 20 and 25', 5)),
    'gcd 6, 9, ,,,,     12       15' 	=> test_zci(build_answer('6, 9, 12 and 15', 3)),
    'gcd 2 3' 				=> test_zci(build_answer('2 and 3', 1)),
    'gcd 2 3 5' 			=> test_zci(build_answer('2, 3 and 5', 1)),
    'gcd 0 2' 				=> test_zci(build_answer('0 and 2', 2)),
    'gcd 0 0' 				=> test_zci(build_answer('0 and 0', 0))
);

done_testing;
