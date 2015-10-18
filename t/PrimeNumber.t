#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "prime";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::PrimeNumber )],
    'prime numbers between 4 and 100' => test_zci("5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97",
        structured_answer => {
            input     => [4, 100],
            operation => 'Prime numbers between',
            result    => "5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97",
        }
    ),
    'prime numbers between 12.6 and 99.7' => test_zci("13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97",
        structured_answer => {
            input     => [12.6, 99.7],
            operation => 'Prime numbers between',
            result    => "13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97",
        }
    ),
    'prime numbers between 23 and 5' => test_zci("5, 7, 11, 13, 17, 19, 23",
        structured_answer => {
            input     => [5, 23],
            operation => 'Prime numbers between',
            result    => "5, 7, 11, 13, 17, 19, 23",
        }
    ),
    'prime numbers between 5 and 5' => test_zci("5",
        structured_answer => {
            input     => [5, 5],
            operation => 'Prime numbers between',
            result    => "5",
        }
    ),
    'prime numbers between 7.4' => test_zci("2, 3, 5, 7",
        structured_answer => {
            input     => [1, 7.4],
            operation => 'Prime numbers between',
            result    => "2, 3, 5, 7",
        }
    ),
    'prime num between 11 and 34' => test_zci("11, 13, 17, 19, 23, 29, 31",
        structured_answer => {
            input     => [11, 34],
            operation => 'Prime numbers between',
            result    => "11, 13, 17, 19, 23, 29, 31",
        }
    ),
    'prime number between 1010 and 1048' => test_zci("1013, 1019, 1021, 1031, 1033, 1039",
        structured_answer => {
            input     => [1010, 1048],
            operation => 'Prime numbers between',
            result    => "1013, 1019, 1021, 1031, 1033, 1039",
        }
    ),
    'prime numbers between 10010 and 10036' => test_zci("None",
        structured_answer => {
            input     => [10010, 10036],
            operation => 'Prime numbers between',
            result    => "None",
        }
    ),
    'prime numbers between' => test_zci("None",
        structured_answer => {
            input     => [1, 1],
            operation => 'Prime numbers between',
            result    => "None",
        }
    ),
    'prime numbers between -3.4 and 5.7' => test_zci("2, 3, 5",
        structured_answer => {
            input     => [-3.4, 5.7],
            operation => 'Prime numbers between',
            result    => "2, 3, 5",
        }
    ),
    'prime numbers between -3.4 and -5.7' => test_zci("None",
        structured_answer => {
            input     => [-5.7, -3.4],
            operation => 'Prime numbers between',
            result    => "None",
        }
    ),
    'prime numbers between hello and zebra' => undef,
    'prime numbe between 3 and 45' => undef,
    'prime numbers between 3 and four' => undef,
);

done_testing;
