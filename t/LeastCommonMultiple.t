#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use DDG::GoodieRole::NumberStyler;

zci answer_type => "least_common_multiple";
zci is_cached   => 1;

sub build_structured_answer {
    my ($result, $input_ref) = @_;
    
    my $styler = DDG::GoodieRole::NumberStyler::number_style_for(@$input_ref);
    grep($_=$styler->for_display($_), @$input_ref);
    my $formatted_numbers = join(', ', @$input_ref[0..$#$input_ref-1]) . " and @$input_ref[$#$input_ref]";
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
    'lcm 9 81' => build_test(81,[9,81]),
    'lcm 81 9' => build_test(81,[81,9]),
    '3, 5, 2 least common multiple' => build_test(30,[3, 5, 2]),
    'LCM 3 and 5 and 10 and 2' => build_test(30,[3, 5, 10, 2]),
    '3,5,10,2 lcm' => build_test(30,[3, 5, 10, 2]),
    '3,5, 1000,2 lcm' => build_test(3000,[3, 5, 1000, 2]),
    'lcm 3,90 and 5,000' => build_test(45000,[3,90,5000]),
    'lcm 3,900 and 5,000,30' => build_test(195000,[3900,5000,30]),
    'lcm' => undef,
    'lcm 9' => undef,
    'lcm 9.2' => undef,
    'lcm 9 2.5' => undef,
    'lcm 7.9 2.5' => undef,
);

done_testing;
