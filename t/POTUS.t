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
        'Barack Obama',
        '44th President of the United States'
    ),
    'who is the fourth president of the united states' => build_test(
        'James Madison was the 4th President of the United States.',
        'James Madison',
        '4th President of the United States'
    ),
    'who is the nineteenth president of the united states' => build_test(
        'Rutherford B. Hayes was the 19th President of the United States.',
        'Rutherford B. Hayes',
        '19th President of the United States'
    ),
    'who was the 1st president of the united states' => build_test(
        'George Washington was the 1st President of the United States.',
        'George Washington',
        '1st President of the United States'
    ),
    'who was the 31 president of the united states' => build_test(
        'Herbert Hoover was the 31st President of the United States.',
        'Herbert Hoover',
        '31st President of the United States',
    ),
    'who was the 22 president of the united states' => build_test(
        'Grover Cleveland was the 22nd President of the United States.',
        'Grover Cleveland',
        '22nd President of the United States'
    ),
    'potus 11' => build_test(
        'James K. Polk was the 11th President of the United States.',
        'James K. Polk',
        '11th President of the United States',
    ),
    'POTUS 24' => build_test(
        'Grover Cleveland was the 24th President of the United States.',
        'Grover Cleveland',
        '24th President of the United States',
    ),
    'who was the twenty-second POTUS?' => build_test(
        'Grover Cleveland was the 22nd President of the United States.',
        'Grover Cleveland',
        '22nd President of the United States',
    ),
    'potus 16' => build_test(
        'Abraham Lincoln was the 16th President of the United States.',
        'Abraham Lincoln',
        '16th President of the United States',
    ),
    'who is the vice president of the united states?' => undef,
    'vice president of the united states' => undef,
    'VPOTUS' => undef
);

done_testing;
