#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "combination";
zci is_cached   => 1;

sub build_test
{
    my ($answer, $question) = @_;
    return test_zci(
        $answer, structured_answer => {
            data => {
                title => $answer,
                subtitle => $question
            },
            templates => {
                group => 'text'
            }
        }
    );
}
ddg_goodie_test(
    [qw( DDG::Goodie::Combination )],
    '10 choose 3' => build_test('120', '10 choose 3'),
    '10 nCr 3' => build_test('120', '10 choose 3'),
    '25 permute 16' => build_test('4.27447366714368 * 10^19', '25 permute 16'), 
    '16 permutation 3' => build_test('3,360', '16 permute 3'), 
    '15 permutation 0' => build_test('1', '15 permute 0'), 
    '1,000 choose 2' => build_test('499,500', '1,000 choose 2'), 
    '0 choose 100' => undef,
    '10 choose 100' => undef,
    '10.5 choose 1' => undef,
    '1.000,5 choose 2' => undef,
    '1000000000000 choose 2000' => undef,
);

done_testing;
