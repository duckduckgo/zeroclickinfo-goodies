#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'palindrome';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Palindrome
        )],
        'is foo a palindrome?' => test_zci('foo is not a palindrome.'),
        'is foof a palindrome?' => test_zci('foof is a palindrome.'),
);

done_testing;

