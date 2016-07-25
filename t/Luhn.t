#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "luhn";
zci is_cached   => 1;

sub build_structured_answer {
    my ($result, $input) = @_;
    return $result,
        structured_answer => {       
            data => {
                title => $result,
                subtitle => "Luhn check digit for $input"
            },
            templates => {
                group   => 'text',
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Luhn )],
    'luhn 1' => build_test('8', '1'),,
    'luhn 4242 4242 424' => build_test('2', '4242 4242 424'),
    'luhn 42424242424' => build_test('2', '42424242424'),
    '750318923 luhn' => build_test('0', '750318923'),
    'luhn j' => undef,
    '123O9 93 luhn' => undef,
);

done_testing;
