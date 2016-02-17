#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "prime";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::PrimeNumber )],
    'prime numbers between 4 and 100' => test_zci(
        "5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97",
        make_structured_answer(4, 100, "5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97")
    ),
    'prime numbers between 12.6 and 99.7' => test_zci(
        "13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97",
        make_structured_answer(12.6, 99.7, "13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97")
    ),
    'prime numbers between 23 and 5' => test_zci(
        "5, 7, 11, 13, 17, 19, 23",
        make_structured_answer(5, 23, "5, 7, 11, 13, 17, 19, 23")
    ),
    'prime numbers between 5 and 5' => test_zci(
        "5",
        make_structured_answer(5, 5, "5")
    ),
    'prime numbers between 7.4' => test_zci(
        "2, 3, 5, 7",
        make_structured_answer(1, 7.4, "2, 3, 5, 7")
    ),
    'prime num between 11 and 34' => test_zci(
        "11, 13, 17, 19, 23, 29, 31",
        make_structured_answer(11, 34, "11, 13, 17, 19, 23, 29, 31")
    ),
    'prime number between 1010 and 1048' => test_zci(
        "1013, 1019, 1021, 1031, 1033, 1039",
        make_structured_answer(1010, 1048, "1013, 1019, 1021, 1031, 1033, 1039")
    ),
    'prime numbers between 10010 and 10036' => test_zci(
        "None",
        make_structured_answer(10010, 10036, "None")
    ),
    'prime numbers between' => test_zci(
        "None",
        make_structured_answer(1, 1, "None")
    ),
    'prime numbers between -3.4 and 5.7' => test_zci(
        "2, 3, 5",
        make_structured_answer(-3.4, 5.7, "2, 3, 5")
    ),
    'prime numbers between -3.4 and -5.7' => test_zci(
        "None",
        make_structured_answer(-5.7, -3.4, "None")
    ),
    'prime numbers between hello and zebra' => undef,
    'prime numbe between 3 and 45' => undef,
    'prime numbers between 3 and four' => undef,
);

sub make_structured_answer {
    my ($start, $end, $description ) = @_;
    return structured_answer => {
        id => 'prime_number',
        name => 'Answer',
        data => {
            title => "Prime numbers between $start and $end",
            description => $description,
        },
        templates => {
            group => 'text',
            options => {
                chompContent => 1
            }
        }
    };
};

done_testing;
