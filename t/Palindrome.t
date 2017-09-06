#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'palindrome';
zci is_cached => 1;

sub build_sum_answer {
    my($title, $subtitle) = @_;
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

sub build_sum_test { test_zci(build_sum_answer(@_)) }

ddg_goodie_test(
    [qw(
        DDG::Goodie::Palindrome
    )],
    'is foo a palindrome?' => build_sum_test('No', '"foo" is not a palindrome.'),
    'foo a palindrome?' => build_sum_test('No', '"foo" is not a palindrome.'),
    'foof a palindrome?' => build_sum_test('Yes', '"foof" is a palindrome.'),
    'is foof a palindrome?' => build_sum_test('Yes', '"foof" is a palindrome.'),
    'is A dank, sad nap. Eels sleep and ask nada. a palindrome?' => build_sum_test('Yes', '"A dank, sad nap. Eels sleep and ask nada." is a palindrome.'),
    'is a dank, sad nap. eels sleep and ask nada. a palindrome?' => build_sum_test('Yes', '"a dank, sad nap. eels sleep and ask nada." is a palindrome.'),
    'is dad a palindrome?' => build_sum_test('Yes', '"dad" is a palindrome.'),

    # Invalid input
    'what is a palindrome?' => undef,
    'I Palindrome I' => undef,
);

done_testing;
