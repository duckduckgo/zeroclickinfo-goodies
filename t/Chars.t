#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'chars';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Chars
        )],

        # string can be inside quotes, and quotes shouldn't be counted as characters
        'chars in "my string"' => test_zci('"my string" is 9 characters long.'),

        # string shouldn't need quotes
        'chars in my string' => test_zci('"my string" is 9 characters long.'),

        # extra spaces shouldn't be counted
        'chars in         my string    ' => test_zci('"my string" is 9 characters long.'),

        # one character strings should say '1 character long' instead of '1 characters long'
        'chars in "1"' => test_zci('"1" is 1 character long.'),

        # check each trigger
        'chars "my string"' => test_zci('"my string" is 9 characters long.'),
        'chars in "my string"' => test_zci('"my string" is 9 characters long.'),
        'num chars "my string"' => test_zci('"my string" is 9 characters long.'),
        '"my string" num chars' => test_zci('"my string" is 9 characters long.'),
        'num chars in "my string"' => test_zci('"my string" is 9 characters long.'),
        'num characters "my string"' => test_zci('"my string" is 9 characters long.'),
        '"my string" num characters' => test_zci('"my string" is 9 characters long.'),
        'num characters in "my string"' => test_zci('"my string" is 9 characters long.'),
        'char count "my string"' => test_zci('"my string" is 9 characters long.'),
        '"my string" char count' => test_zci('"my string" is 9 characters long.'),
        'char count in "my string"' => test_zci('"my string" is 9 characters long.'),
        'character count "my string"' => test_zci('"my string" is 9 characters long.'),
        '"my string" character count' => test_zci('"my string" is 9 characters long.'),
        'character count in "my string"' => test_zci('"my string" is 9 characters long.'),
        'length of string "my string"' => test_zci('"my string" is 9 characters long.'),
        '"my string" length of string' => test_zci('"my string" is 9 characters long.'),
        'length in characters "my string"' => test_zci('"my string" is 9 characters long.'),
        '"my string" length in characters' => test_zci('"my string" is 9 characters long.'),
        'length in chars "my string"' => test_zci('"my string" is 9 characters long.'),
        '"my string" length in chars' => test_zci('"my string" is 9 characters long.'),

 );

done_testing;
