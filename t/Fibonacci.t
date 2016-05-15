#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'fibonacci';
zci is_cached   => 1;

sub build_test
{
    my ($text_answer, $answer, $subtitle) = @_;
    return test_zci($text_answer, structured_answer => {
        data => {
           title => $answer,
           subtitle => "$subtitle Fibonacci number"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw(DDG::Goodie::Fibonacci)],
    'fib 7' => build_test('The 7th fibonacci number is 13 (assuming f(0) = 0).', 13, '7th'),
    'fibonacci 33' => build_test('The 33rd fibonacci number is 3524578 (assuming f(0) = 0).', 3524578, '33rd'),
    q`what's the 6th fibonacci number?` => build_test('The 6th fibonacci number is 8 (assuming f(0) = 0).', 8, '6th'),
    '10th number in the fibonacci sequence?' => build_test('The 10th fibonacci number is 55 (assuming f(0) = 0).', 55, '10th'),
    'what is the 18th number in the fibonacci series' => build_test('The 18th fibonacci number is 2584 (assuming f(0) = 0).', 2584, '18th'),
    'tell a fib'                  => undef,
    'what are fibonacci numbers?' => undef,
);

done_testing;
