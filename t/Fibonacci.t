#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'fibonacci';
zci is_cached   => 1;

sub build_structured_answer {
    my ($text_answer, $title, $subtitle) = @_;

    return $text_answer, structured_answer => {
        data => {
            title => "$title",
            subtitle => "$subtitle"
        },
        templates => {
            group => 'text'
        }
    };
}

sub build_test { test_zci(build_structured_answer(@_)) };

ddg_goodie_test(
    [qw(DDG::Goodie::Fibonacci)],
    'fib 7' => build_test("The 7th fibonacci number is 13 (assuming f(0) = 0)", 13, "7th Fibonacci number"),
    'fibonacci 33' => build_test("The 33rd fibonacci number is 3524578 (assuming f(0) = 0)", 3524578, '33rd Fibonacci number'),
    q`what's the 6th fibonacci number?` => build_test("The 6th fibonacci number is 8 (assuming f(0) = 0)", 8, '6th Fibonacci number'),
    '10th number in the fibonacci sequence?' => build_test("The 10th fibonacci number is 55 (assuming f(0) = 0)", 55, '10th Fibonacci number'),
    'what is the 18th number in the fibonacci series' => build_test("The 18th fibonacci number is 2584 (assuming f(0) = 0)", 2584, '18th Fibonacci number'),
    'What is the 2nd fibonacci number' => build_test("The 2nd fibonacci number is 1 (assuming f(0) = 0)", 1, '2nd Fibonacci number'),
    'what is the 250001 fib' => undef,
    'is 14 a fibonacci number' => build_test("14 is not a Fibonacci number", "No", '14 is not a Fibonacci number'),
    'is 13 in the fibonacci sequence?' => build_test("13 is a Fibonacci number", "Yes", '13 is a Fibonacci number'),
    'is 6 a fib?' => build_test("6 is not a Fibonacci number", "No", "6 is not a Fibonacci number"),
    'is 1000000000000000000000000000000000000000000000 a fib' => undef,
    'tell a fib'                  => undef,
    'what are fibonacci numbers?' => undef,
);

done_testing;
