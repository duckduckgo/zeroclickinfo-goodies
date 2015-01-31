#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "greatest_common_factor";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::GreatestCommonFactor )],
    'gcf 9 81' => test_zci(
        'Greatest common factor of 9 and 81 is 9.',
        structured_answer => {
            input     => [9, 81],
            operation => 'Greatest common factor',
            result    => 9
        }
    ),
    '1000 100 greatest common factor' => test_zci(
        'Greatest common factor of 100 and 1000 is 100.',
        structured_answer => {
            input     => [100, 1000],
            operation => 'Greatest common factor',
            result    => 100
        }
    ),
    'GCF 12 76' => test_zci(
        'Greatest common factor of 12 and 76 is 4.',
        structured_answer => {
            input     => [12, 76],
            operation => 'Greatest common factor',
            result    => 4
        }
    ),
    'GCF 121 11' => test_zci(
        'Greatest common factor of 11 and 121 is 11.',
        structured_answer => {
            input     => [11, 121],
            operation => 'Greatest common factor',
            result    => 11
        }
    ),
    '99 9 greatest common factor' => test_zci(
        'Greatest common factor of 9 and 99 is 9.',
        structured_answer => {
            input     => [9, 99],
            operation => 'Greatest common factor',
            result    => 9
        }
    ),
);

done_testing;
