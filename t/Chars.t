#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'chars';
zci is_cached   => 1;

my @my_string = (
    '"my string" is 9 characters long.',
    structured_answer => {
        input     => ['my string'],
        operation => 'Character count',
        result    => 9
    });

ddg_goodie_test(
    [qw( DDG::Goodie::Chars)],

    # string can be inside double quotes, and quotes shouldn't be counted as characters
    'chars in "my string"' => test_zci(@my_string),

    # string can be inside single quotes, and single quotes shouldn't be counted as characters
    "chars in 'my string'" => test_zci(@my_string),

    # string shouldn't need quotes
    'chars in my string' => test_zci(@my_string),

    # extra spaces shouldn't be counted
    'chars in         my string    ' => test_zci(@my_string),

    # extra spaces before 'in' should still trigger
    'chars     in my string' => test_zci(@my_string),

    # one character strings should say '1 character long' instead of '1 characters long'
    'chars in "1"' => test_zci(
        '"1" is 1 character long.',
        structured_answer => {
            input     => ['1'],
            operation => 'Character count',
            result    => 1
        }
    ),

    # trigger plus empty quotes should return a length of 0.
    'chars in ""' => test_zci(
        '"" is 0 characters long.',
        structured_answer => {
            input     => [''],
            operation => 'Character count',
            result    => 0
        }
    ),

    #####
    # triggers that SHOULD load the IA

    'chars "my string"'                   => test_zci(@my_string),
    'chars in "my string"'                => test_zci(@my_string),
    'number of chars in "my string"'      => test_zci(@my_string),
    '"my string" number of chars'         => test_zci(@my_string),
    'number of characters in "my string"' => test_zci(@my_string),
    '"my string" number of characters'    => test_zci(@my_string),
    'num chars "my string"'               => test_zci(@my_string),
    '"my string" num chars'               => test_zci(@my_string),
    'num chars in "my string"'            => test_zci(@my_string),
    'num characters "my string"'          => test_zci(@my_string),
    '"my string" num characters'          => test_zci(@my_string),
    'num characters in "my string"'       => test_zci(@my_string),
    'char count "my string"'              => test_zci(@my_string),
    '"my string" char count'              => test_zci(@my_string),
    'char count in "my string"'           => test_zci(@my_string),
    'character count "my string"'         => test_zci(@my_string),
    '"my string" character count'         => test_zci(@my_string),
    'character count in "my string"'      => test_zci(@my_string),
    'length of string "my string"'        => test_zci(@my_string),
    '"my string" length of string'        => test_zci(@my_string),
    'length in characters "my string"'    => test_zci(@my_string),
    '"my string" length in characters'    => test_zci(@my_string),
    'length in chars "my string"'         => test_zci(@my_string),
    '"my string" length in chars'         => test_zci(@my_string),

    #####
    # triggers that SHOULD NOT load the IA

    # a trigger query with no text should not trigger the IA
    'chars' => undef,

    # a trigger query plus the word 'in' should not trigger the IA
    'chars in' => undef,

    # a trigger query plus the word 'in' and spaces should not trigger the IA
    'chars in      ' => undef,

    # searches for TV characters should not load the IA
    'Sopranos characters'        => undef,
    'characters in the Sopranos' => undef,

    # generic length searches should not load the IA
    'length of the Nile River' => undef,
    'Titanic movie length'     => undef,
);

done_testing;

