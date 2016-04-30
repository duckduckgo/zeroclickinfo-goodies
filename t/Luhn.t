#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "luhn";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Luhn )],
    'luhn 1' => test_zci(
        'The Luhn check digit of 1 is 8.',
        structured_answer => {
            input     => ['1'],
            operation => 'Luhn',
            result    => 8
        }
    ),
    'luhn 4242 4242 424' => test_zci(
        'The Luhn check digit of 4242 4242 424 is 2.',
        structured_answer => {
            input     => ['4242 4242 424'],
            operation => 'Luhn',
            result    => 2
        }
    ),
    '750318923 luhn' => test_zci(
        'The Luhn check digit of 750318923 is 0.',
        structured_answer => {
            input     => ['750318923'],
            operation => 'Luhn',
            result    => 0
        }
    ),
    'luhn j' => undef,
    '123O9 93 luhn' => undef,
);

done_testing;
