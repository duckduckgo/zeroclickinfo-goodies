#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'chars';
zci is_cached   => 1;

sub build_structured_answer {
    my ($len, $str) = @_;

    # pluralize the word 'character' unless length is 1.
    # note that this works for length=0, i.e. we'll correctly get '0 characters'.
    my $characters_pluralized = ($len == 1 ? 'character' : 'characters');

    return qq("$str" is $len $characters_pluralized long.),
      structured_answer => {
        data => {
            title    => $len,
            subtitle => "Character count: $str"
        },
        templates => {
            group => 'text'
        }
      };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Chars)],

    # string can be inside double quotes, and quotes shouldn't be counted as characters
    'num chars in "my string"' => build_test(9, 'my string'),

    # string can be inside single quotes, and single quotes shouldn't be counted as characters
    "num chars in 'my string'" => build_test(9, 'my string'),

    # string shouldn't need quotes
    'num chars in my string' => build_test(9, 'my string'),

    # extra spaces shouldn't be counted
    'num chars in         my string    ' => build_test(9, 'my string'),

    # extra spaces before 'in' should still trigger
    'num chars     in my string' => build_test(9, 'my string'),

    # one character strings should say '1 character long' instead of '1 characters long'
    'num chars in "1"' => build_test(1, '1'),

    # trigger plus empty quotes should return a length of 0.
    'num chars in ""' => build_test(0, ''),

    #above triggers should work the same way with the word 'of'
    # string can be inside double quotes, and quotes shouldn't be counted as characters
    'num chars of "my string"' => build_test(9, 'my string'),

    # string can be inside single quotes, and single quotes shouldn't be counted as characters
    "num chars of 'my string'" => build_test(9, 'my string'),

    # string shouldn't need quotes
    'num chars of my string' => build_test(9, 'my string'),

    # extra spaces shouldn't be counted
    'num chars of         my string    ' => build_test(9, 'my string'),

    # extra spaces before 'in' should still trigger
    'num chars     of my string' => build_test(9, 'my string'),

    # one character strings should say '1 character long' instead of '1 characters long'
    'num chars of "1"' => build_test(1, '1'),

    # trigger plus empty quotes should return a length of 0.
    'num chars of ""' => build_test(0, ''),



    #####
    # triggers that SHOULD load the IA

    'number of chars in "my string"'      => build_test(9, 'my string'),
    'number of characters in "my string"' => build_test(9, 'my string'),
    'num chars "my string"'               => build_test(9, 'my string'),
    'num chars in "my string"'            => build_test(9, 'my string'),
    'num characters "my string"'          => build_test(9, 'my string'),
    'num characters in "my string"'       => build_test(9, 'my string'),
    'char count "my string"'              => build_test(9, 'my string'),
    'char count in "my string"'           => build_test(9, 'my string'),
    'character count "my string"'         => build_test(9, 'my string'),
    'character count in "my string"'      => build_test(9, 'my string'),
    'length in chars "my string"'         => build_test(9, 'my string'),

    # triggers that SHOULD NOT load the IA
    'length of string "my string"'	  => undef,

    # a trigger query with no text should not trigger the IA
    'num chars' => undef,

    # a trigger query plus the word 'in' should not trigger the IA
    'num chars in' => undef,

    # a trigger query plus the word 'in' and spaces should not trigger the IA
    'num chars in      ' => undef,

    #above triggers with 'of' should also not not trigger the IA

    # a trigger query plus the word 'of' should not trigger the IA
    'num chars of' => undef,

    # a trigger query plus the word 'of' and spaces should not trigger the IA
    'num chars of      ' => undef,


    # searches for TV characters should not load the IA
    'Sopranos characters'        => undef,
    'characters in the Sopranos' => undef,

    # generic length searches should not load the IA
    'length of the Nile River' => undef,
    'Titanic movie length'     => undef,
);

done_testing;
