#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'potus';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::POTUS)],
    'who is president of the united states' => test_zci(
        'Barack Obama is the 44th President of the United States.',
        structured_answer => {
            input     => ['44th'],
            operation => 'President of the United States',
            result    => 'Barack Obama'
        }
    ),
    'who is the fourth president of the united states' => test_zci(
        'James Madison was the 4th President of the United States.',
        structured_answer => {
            input     => ['4th'],
            operation => 'President of the United States',
            result    => 'James Madison'
        }
    ),
    'who is the nineteenth president of the united states' => test_zci(
        'Rutherford B. Hayes was the 19th President of the United States.',
        structured_answer => {
            input     => ['19th'],
            operation => 'President of the United States',
            result    => 'Rutherford B. Hayes'
        }
    ),
    'who was the 1st president of the united states' => test_zci(
        'George Washington was the 1st President of the United States.',
        structured_answer => {
            input     => ['1st'],
            operation => 'President of the United States',
            result    => 'George Washington'
        }
    ),
    'who was the 31 president of the united states' => test_zci(
        'Herbert Hoover was the 31st President of the United States.',
        structured_answer => {
            input     => ['31st'],
            operation => 'President of the United States',
            result    => 'Herbert Hoover'
        }
    ),
    'who was the 22 president of the united states' => test_zci(
        'Grover Cleveland was the 22nd President of the United States.',
        structured_answer => {
            input     => ['22nd'],
            operation => 'President of the United States',
            result    => 'Grover Cleveland'
        }
    ),
    'potus 11' => test_zci(
        'James K. Polk was the 11th President of the United States.',
        structured_answer => {
            input     => ['11th'],
            operation => 'President of the United States',
            result    => 'James K. Polk'
        }
    ),
    'POTUS 24' => test_zci(
        'Grover Cleveland was the 24th President of the United States.',
        structured_answer => {
            input     => ['24th'],
            operation => 'President of the United States',
            result    => 'Grover Cleveland'
        }
    ),
    'who was the twenty-second POTUS?' => test_zci(
        'Grover Cleveland was the 22nd President of the United States.',
        structured_answer => {
            input     => ['22nd'],
            operation => 'President of the United States',
            result    => 'Grover Cleveland'
        }
    ),
    'potus 16' => test_zci(
        'Abraham Lincoln was the 16th President of the United States.',
        structured_answer => {
            input     => ['16th'],
            operation => 'President of the United States',
            result    => 'Abraham Lincoln'
        }
    ),
);

done_testing;
