#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'palindrome';
zci is_cached => 1;

ddg_goodie_test(
    [qw(
                DDG::Goodie::Palindrome
        )],
    'is foo a palindrome?' => test_zci('"foo" is not a palindrome.'),
    'foo a palindrome?' => test_zci('"foo" is not a palindrome.'),
    'is foof a palindrome?' => test_zci('"foof" is a palindrome.'),
    'foof a palindrome?' => test_zci('"foof" is a palindrome.'),
    'is A dank, sad nap. Eels sleep and ask nada. a palindrome?' => test_zci('"A dank, sad nap. Eels sleep and ask nada." is a palindrome.'),
    'is a dank, sad nap. eels sleep and ask nada. a palindrome?' => test_zci('"a dank, sad nap. eels sleep and ask nada." is a palindrome.'),
    'is dad a palindrome?' => test_zci('"dad" is a palindrome.'),
);

done_testing;
