#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'next_permutation';
zci is_cached   => 1;

sub build_structured_answer {
    my ($sequence, $result) = @_;

    return "Next Permutation of the Sequence is $result",
        structured_answer => {

            data => {
                title    => $result,
                subtitle => "Lexicographically Next Permutation For Sequence: $sequence"
            },

            templates => {
                group => 'text'
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::NextPermutation )],
    'next permutation 12345' => build_test('12345','12354'),
    'next permutation abcd' => build_test('abcd','abdc'),
    'next permutation dhck' => build_test('dhck', 'dhkc'),
    'next permutation dkhc' => build_test('dkhc', 'hcdk'),
    'next permutation ab' => build_test('ab', 'ba'),
    'next permutation 218765' => build_test('218765', '251678'),
    'next perm 12345' => build_test('12345','12354'),
    'next perm abcd' => build_test('abcd','abdc'),
    'next perm dhck' => build_test('dhck', 'dhkc'),
    'next perm dkhc' => build_test('dkhc', 'hcdk'),
    'next perm ab' => build_test('ab', 'ba'),
    'next perm 218765' => build_test('218765', '251678'),
    'next permutation 54321' => undef, 
    'next permutation bb' => undef,
    'next permutation 4321' => undef, 
    'next permutation ab45' => undef,
    'next permuta 4321' => undef,
    'permutation 4567' => undef,
);

done_testing;
