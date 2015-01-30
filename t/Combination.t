#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "combination";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Combination )],
    '10 choose 3' => test_zci('120',
        structured_answer => {
            input     => ['10 choose 3'],
            operation => 'Calculate',
            result    => '120',
        }
    ),
    '10 nCr 3' => test_zci('120',
        structured_answer => {
            input     => ['10 choose 3'],
            operation => 'Calculate',
            result    => '120',
        }
    ),
    '25 permute 16' => test_zci('4.27447366714368 * 10^19',
        structured_answer =>  {
            input     => ['25 permute 16'],
            operation => 'Calculate',
            result    => '4.27447366714368 * 10^19'
        }
    ), 
    '16 permutation 3' => test_zci('3,360',
        structured_answer =>  {
            input     => ['16 permute 3'],
            operation => 'Calculate',
            result    => '3,360'
        }
    ), 
    '15 permutation 0' => test_zci('1',
        structured_answer  => {
            input     => ['15 permute 0'],
            operation => 'Calculate',
            result    => '1'
        }
    ), 
    '1,000 choose 2' => test_zci('499,500',
        structured_answer  => {
            input     => ['1,000 choose 2'],
            operation => 'Calculate',
            result    => '499,500'
        }
    ), 
    '0 choose 100' => undef,
    '10 choose 100' => undef,
    '10.5 choose 1' => undef,
    '1.000,5 choose 2' => undef,
    '1000000000000 choose 2000' => undef,
);

done_testing;
