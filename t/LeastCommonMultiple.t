#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "least_common_multiple";
zci is_cached   => 1;

sub build_structured_answer {
    my ($result, @input) = @_;
    
    my $formatted_numbers = join(', ', @input);
    $formatted_numbers =~ s/, ([^,]*)$/ and $1/;
    return "Least common multiple of $formatted_numbers is $result.",
        structured_answer => {
            data => {
                title    => $result,
                subtitle => "Least common multiple of $formatted_numbers",
            },

            templates => {
                group => "text"
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::LeastCommonMultiple )],
    'lcm 9 81' => build_test(81,(9,81)),
    'lcm 81 9' => build_test(81,(81,9)),
    '3, 5, 2 least common multiple' => build_test(30,(3, 5, 2)),
    'lcm 9' => build_test(9,(9)),
    'LCM 3 and 5 and 10 and 2' => build_test(30,(3, 5, 10, 2)),
    '3,5,10,2 lcm' => build_test(30,(3, 5, 10, 2)),
    'lcm' => undef,
    'lcm 9.2' => undef,
    'lcm 9 2.5' => undef,
    'lcm 7.9 2.5' => undef,
);

done_testing;
