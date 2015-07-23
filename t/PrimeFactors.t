#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => "prime_factors";
zci is_cached => 1;

sub build_answer {
    my ($subtitle, $title) = @_;
    
    return structured_answer => {
        id => 'prime_factors',
        name => 'Answer',
        data => {
            title => $title,
            subtitle => $subtitle
        },
        templates => {
            group => 'text'
        }
    }
}

ddg_goodie_test(
	[qw(
		DDG::Goodie::PrimeFactors
	)],
    '72 prime factors' => test_zci('The prime factorization of 72 is 2^3 × 3^2',
                                    build_answer('72 - Prime Factors', '2³ × 3²')),
    'prime factors of 111' => test_zci('The prime factorization of 111 is 3 × 37',
                                    build_answer('111 - Prime Factors', '3 × 37')),
    'prime factors of 30' => test_zci('The prime factorization of 30 is 2 × 3 × 5',
                                    build_answer('30 - Prime Factors', '2 × 3 × 5')),
    'prime factorization of 45' => test_zci('The prime factorization of 45 is 3^2 × 5',
                                    build_answer('45 - Prime Factors', '3² × 5')),
    'factorize 128' => test_zci('The prime factorization of 128 is 2^7',
                                    build_answer('128 - Prime Factors', '2⁷')),
    '42 prime factorize' => test_zci('The prime factorization of 42 is 2 × 3 × 7',
                                    build_answer('42 - Prime Factors', '2 × 3 × 7')),
    'optimus prime 45' => undef
);

done_testing;
