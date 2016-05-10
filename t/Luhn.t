#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "luhn";
zci is_cached   => 1;

sub build_structured_answer {
    my ($result, $formatted) = @_;
    return $result,
        structured_answer => {
            data => {
                title    => $result,
                subtitle => $formatted,
            },
            templates => {
                group   => 'text',
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Luhn )],
    'luhn 1' => build_test('8', 'The Luhn check digit of 1 is 8.'),,
    'luhn 4242 4242 424' => build_test('2', 'The Luhn check digit of 4242 4242 424 is 2.'),
    '750318923 luhn' => build_test('0', 'The Luhn check digit of 750318923 is 0.'),
    'luhn j' => undef,
    '123O9 93 luhn' => undef,
);

done_testing;
