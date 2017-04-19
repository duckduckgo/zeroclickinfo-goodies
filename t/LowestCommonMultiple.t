#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'lowest_common_multiple';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my ($numbers, $result) = @_;

    return "Lowest Common Multiple of $numbers is $result.",
        structured_answer => {
            data => {
                title    => $result,
                subtitle => "Lowest Common Multiple: $numbers"
            },
            templates => {
                group => "text"
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::LowestCommonMultiple )],
    'lcm 9 81'                        => build_test('9 and 81', 81),
   
    'Lowest Common Multiple  4 6'     => build_test('4 and 6', 12),
  
    
    #Tests that should fail
    'lcm 2'                           => undef,
);


done_testing;
