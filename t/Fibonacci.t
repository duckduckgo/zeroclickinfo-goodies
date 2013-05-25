#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'fibonacci';
zci is_cached => 1;

ddg_goodie_test(
        [qw(DDG::Goodie::Fibonacci)],
        'fib 7' => test_zci('The 7th fibonacci number is 13 (assuming f(0) = 0).',
                            html => 'The 7<sup>th</sup> fibonacci number is 13 (assuming f(0) = 0).'),
        'fibonacci 33' => test_zci('The 33rd fibonacci number is 3524578 (assuming f(0) = 0).',
                            html => 'The 33<sup>rd</sup> fibonacci number is 3524578 (assuming f(0) = 0).'), 
);

done_testing;
