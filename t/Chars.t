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
    'chars in "my string"' => build_test(9, 'my string'),

    # string can be inside single quotes, and single quotes shouldn't be counted as characters
    "chars in 'my string'" => build_test(9, 'my string'),

    # string shouldn't need quotes
    'chars in my string' => build_test(9, 'my string'),

    # extra spaces shouldn't be counted
    'chars in         my string    ' => build_test(9, 'my string'),

    # extra spaces before 'in' should still trigger
    'chars     in my string' => build_test(9, 'my string'),

    # one character strings should say '1 character long' instead of '1 characters long'
    'chars in "1"' => build_test(1, '1'),

    # trigger plus empty quotes should return a length of 0.
    'chars in ""' => build_test(0, ''),

    #####
    # triggers that SHOULD load the IA

    'chars "my string"'                   => build_test(9, 'my string'),
    'chars in "my string"'                => build_test(9, 'my string'),
    'number of chars in "my string"'      => build_test(9, 'my string'),
    '"my string" number of chars'         => build_test(9, 'my string'),
    'number of characters in "my string"' => build_test(9, 'my string'),
    '"my string" number of characters'    => build_test(9, 'my string'),
    'num chars "my string"'               => build_test(9, 'my string'),
    '"my string" num chars'               => build_test(9, 'my string'),
    'num chars in "my string"'            => build_test(9, 'my string'),
    'num characters "my string"'          => build_test(9, 'my string'),
    '"my string" num characters'          => build_test(9, 'my string'),
    'num characters in "my string"'       => build_test(9, 'my string'),
    'char count "my string"'              => build_test(9, 'my string'),
    '"my string" char count'              => build_test(9, 'my string'),
    'char count in "my string"'           => build_test(9, 'my string'),
    'character count "my string"'         => build_test(9, 'my string'),
    '"my string" character count'         => build_test(9, 'my string'),
    'character count in "my string"'      => build_test(9, 'my string'),
    'length of string "my string"'        => build_test(9, 'my string'),
    '"my string" length of string'        => build_test(9, 'my string'),
    'length in characters "my string"'    => build_test(9, 'my string'),
    '"my string" length in characters'    => build_test(9, 'my string'),
    'length in chars "my string"'         => build_test(9, 'my string'),
    '"my string" length in chars'         => build_test(9, 'my string'),

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
