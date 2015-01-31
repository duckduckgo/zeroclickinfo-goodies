#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "birth_stone";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::BirthStone )],
    'april birth stone' => test_zci(
        'April birthstone: Diamond',
        structured_answer => {
            input     => ['April'],
            operation => 'Birthstone',
            result    => 'Diamond'
        }
    ),
    'birthstone JUNE' => test_zci(
        'June birthstone: Pearl',
        structured_answer => {
            input     => ['June'],
            operation => 'Birthstone',
            result    => 'Pearl'
        }
    ),
    'DecEmber birthstone' => test_zci(
        'December birthstone: Turquoise',
        structured_answer => {
            input     => ['December'],
            operation => 'Birthstone',
            result    => 'Turquoise'
        }
    ),
    'birthstone april' => test_zci(
        'April birthstone: Diamond',
        structured_answer => {
            input     => ['April'],
            operation => 'Birthstone',
            result    => 'Diamond'
        }
    ),
    'may birth stone' => test_zci(
        'May birthstone: Emerald',
        structured_answer => {
            input     => ['May'],
            operation => 'Birthstone',
            result    => 'Emerald'
        }
    ),
);

done_testing;
