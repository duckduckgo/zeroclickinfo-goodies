#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "factors";
zci is_cached   => 1;

sub build_test
{
    my ($text_answer, $input, $answer) = @_;
    return test_zci($text_answer, structured_answer =>{
        data => {
            title => $answer,
            subtitle => "Factors of: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Factors)],
    '30 factors'    => build_test('Factors of 30: 1, 2, 3, 5, 6, 10, 15, 30', '30', '1, 2, 3, 5, 6, 10, 15, 30'),
    'factors of 72' => build_test('Factors of 72: 1, 2, 3, 4, 6, 8, 9, 12, 18, 24, 36, 72', '72', '1, 2, 3, 4, 6, 8, 9, 12, 18, 24, 36, 72'),
    'factors of 30' => build_test('Factors of 30: 1, 2, 3, 5, 6, 10, 15, 30', '30', '1, 2, 3, 5, 6, 10, 15, 30'),
    '72 factors'    => build_test('Factors of 72: 1, 2, 3, 4, 6, 8, 9, 12, 18, 24, 36, 72', '72', '1, 2, 3, 4, 6, 8, 9, 12, 18, 24, 36, 72'),
);

done_testing;
