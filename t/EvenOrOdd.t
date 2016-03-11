#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'even_or_odd';
zci is_cached   => 1;

ddg_goodie_test(
    ['DDG::Goodie::EvenOrOdd'],
    'is 100 even or odd' => test_zci(
        'Even',
        structured_answer => {
            input     => ['100'],
            operation => 'Even or Odd',
            result    => 'Even'
        },
    ),
    'is 9999 even?' => test_zci(
        'Odd',
        structured_answer => {
            input     => ['9999'],
            operation => 'Even or Odd',
            result    => 'Odd'
        },
    ),
    'is -500 even' => test_zci(
        'Even',
        structured_answer => {
            input     => ['-500'],
            operation => 'Even or Odd',
            result    => 'Even'
        },
    ),
    '-4555 even?' => test_zci(
        'Odd',
        structured_answer => {
            input     => ['-4555'],
            operation => 'Even or Odd',
            result    => 'Odd'
        },
    ),
    'is 100000     even' => test_zci(
        'Even',
        structured_answer => {
            input     => ['100000'],
            operation => 'Even or Odd',
            result    => 'Even'
        },
    ),
    'is 10001    even' => test_zci(
        'Odd',
        structured_answer => {
            input     => ['10001'],
            operation => 'Even or Odd',
            result    => 'Odd'
        },
    ),
);

done_testing;
