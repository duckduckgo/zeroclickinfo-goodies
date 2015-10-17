#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "prime";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::PrimeNumber )],
    'prime numbers between 4 and 100' => test_zci(qr/(\d{1,3}\,\s\s)+\d{1,3} \(prime numbers\)/,
        structured_answer => {
            input     => [4, 100],
            operation => 'Prime numbers between',
            result    => qr/(\d{1,3}\,\s\s)+\d{1,3}/,
        }
    ),
);

done_testing;
