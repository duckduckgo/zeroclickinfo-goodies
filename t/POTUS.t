#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'potus';
zci is_cached   => 1;

sub build_test
{
    my ($text, $title, $subtitle) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => $title,
            subtitle => $subtitle
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::POTUS)],
    'who is president of the united states' => build_test(
        'Barack Obama is the 44th President of the United States.',
        '44th President of the United States',
        'Barack Obama'
    ),
    'who is the fourth president of the united states' => test_zci(
        'James Madison was the 4th President of the United States.',
        '4th President of the United States',
        'James Madison'
    ),
    'who is the nineteenth president of the united states' => test_zci(
        'Rutherford B. Hayes was the 19th President of the United States.',
        '19th President of the United States',
        'Rutherford B. Hayes'
    ),
    'who was the 1st president of the united states' => test_zci(
        'George Washington was the 1st President of the United States.',
        '1st President of the United States',
        'George Washington'
    ),
    'who was the 31 president of the united states' => test_zci(
        'Herbert Hoover was the 31st President of the United States.',
        '31st President of the United States',
        'Herbert Hoover'
    ),
    'who was the 22 president of the united states' => test_zci(
        'Grover Cleveland was the 22nd President of the United States.',
        '22nd President of the United States',
        'Grover Cleveland'
    ),
    'potus 11' => test_zci(
        'James K. Polk was the 11th President of the United States.',
        '11th President of the United States',
        'James K. Polk'
    ),
    'POTUS 24' => test_zci(
        'Grover Cleveland was the 24th President of the United States.',
        '24th President of the United States',
        'Grover Cleveland'
    ),
    'who was the twenty-second POTUS?' => test_zci(
        'Grover Cleveland was the 22nd President of the United States.',
        '22nd President of the United States',
        'Grover Cleveland'
    ),
    'potus 16' => test_zci(
        'Abraham Lincoln was the 16th President of the United States.',
        '16th President of the United States',
        'Abraham Lincoln'
    ),
    'who is the vice president of the united states?' => undef,
    'vice president of the united states' => undef
);

done_testing;
