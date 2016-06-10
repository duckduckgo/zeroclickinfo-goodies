#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'fibonacci';
zci is_cached   => 1;

sub build_test
{
    my ($answer, $subtitle) = @_;
    return test_zci("The $subtitle fibonacci number is $answer (assuming f(0) = 0).", structured_answer => {
        data => {
           title => $answer,
           subtitle => "$subtitle Fibonacci number"
        },
        templates => {
            group => 'text'
        }
    });
}

sub build_pred_test
{
    my ($answer, $subtitle) = @_;
    return test_zci("$subtitle a Fibonacci number.", structured_answer => {
	data => {
	    title => $answer,
	    subtitle => "$subtitle a Fibonacci number"
	},
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw(DDG::Goodie::Fibonacci)],
    'fib 7' => build_test(13, '7th'),
    'fibonacci 33' => build_test(3524578, '33rd'),
    q`what's the 6th fibonacci number?` => build_test(8, '6th'),
    '10th number in the fibonacci sequence?' => build_test(55, '10th'),
    'what is the 18th number in the fibonacci series' => build_test(2584, '18th'),
    'What is the 2nd fibonacci number' => build_test(1, '2nd'),
    'what is the 250001 fib' => undef,
    'is 14 a fibonacci number' => build_pred_test("false", '14 is not'),
    'is 13 in the fibonacci sequence?' => build_pred_test("true", '13 is'),
    'is 6 a fib?' => build_pred_test("false", "6 is not"),
    'is 1000000000000000000000000000000000000000000000 a fib' => undef,
    'tell a fib'                  => undef,
    'what are fibonacci numbers?' => undef,
);

done_testing;
