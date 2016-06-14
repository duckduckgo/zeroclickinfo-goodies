#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci is_cached => 1;
zci answer_type => 'frequency';

my @structured_answer = {
    data => ignore(),
    templates => {
        group => "list",
        options => {
            content => "record"
        }
    }
};

# We don't want to test too specifically on the included data, so just confirm
# we got the correct answer.
ddg_goodie_test(
        [qw(
                DDG::Goodie::Frequency
        )],

    "frequency of all in test" => test_zci(
        "e:1/4 s:1/4 t:2/4",
        structured_answer => @structured_answer
    ),

    'frequency of all letters in test' => test_zci(
        'e:1/4 s:1/4 t:2/4',
        structured_answer => @structured_answer
    ),

    'frequency of letters in test' => test_zci(
        'e:1/4 s:1/4 t:2/4',
        structured_answer => @structured_answer
    ),

    'frequency of all characters in test' => test_zci(
        'e:1/4 s:1/4 t:2/4',
        structured_answer => @structured_answer
    ),

    'frequency of all chars in test' => test_zci(
        'e:1/4 s:1/4 t:2/4',
        structured_answer => @structured_answer
    ),

    'frequency of all in testing 1234 ABC!' => test_zci(
        'a:1/10 b:1/10 c:1/10 e:1/10 g:1/10 i:1/10 n:1/10 s:1/10 t:2/10',
        structured_answer => @structured_answer
    ),

    'frequency of all in Assassins!' => test_zci(
        'a:2/9 i:1/9 n:1/9 s:5/9',
        structured_answer => @structured_answer
    ),

    'frequency of a in Atlantic Ocean' => test_zci(
        'a:3/13'.
        structured_answer => @structured_answer
    ),

    'freq of B in battle' => test_zci(
        'b:1/6',
        structured_answer => @structured_answer
    ),

    'freq of s in Spoons' => test_zci(
        's:2/6',
        structured_answer => @structured_answer
    ),

    'frequency of all characters in testing' => test_zci(
        'e:1/7 g:1/7 i:1/7 n:1/7 s:1/7 t:2/7',
        structured_answer => @structured_answer
    ),

    'frequency of B in battle' => test_zci(
        'b:1/6',
        structured_answer => @structured_answer
    )
);

done_testing;
