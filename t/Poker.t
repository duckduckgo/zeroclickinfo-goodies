#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'poker';
zci is_cached => 1;


sub build_answer {
    my ($title, $subtitle) = @_;

    return $subtitle,
        structured_answer => {
            data => {
                title => $title,
                subtitle => $subtitle
            },

            templates => {
                group => 'text',
            }
        };
}

sub build_test { test_zci(build_answer(@_)) }

ddg_goodie_test(
    [
        'DDG::Goodie::Poker'
    ],
    'poker odds flush' => build_test('508 : 1', 'The odds of getting a flush in poker are 508 : 1.'),
    'Probability poker Two Pair' => build_test('4.75%', 'The probability of getting a two pair in poker is 4.75%.'),
    'frequency royal flush poker' => build_test('4 out of 2,598,960', 'The frequency of a royal flush in poker is 4 out of 2,598,960.'),
    'poker odds three of a kind' => build_test('46.3 : 1', 'The odds of getting a three of a kind in poker are 46.3 : 1.'),
    'probability poker flush' => build_test('0.197%', 'The probability of getting a flush in poker is 0.197%.'),

    # Invalid Input
    'poker odds game' => undef,
    'odds of winning poker' => undef,
);

done_testing;
