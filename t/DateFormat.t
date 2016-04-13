#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "date_format";
zci is_cached   => 1;

sub build_structured_answer {
    my %results = @_;

    return "$results{output}",
        structured_answer => {

            data => {
                title => $results{output},
                subtitle => "$results{locale} format for $results{format}",
            },

            templates => {
                group => "text",
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::DateFormat )],
    'MMMd format for en_US' => build_test(
        locale => 'en_US',
        format => 'MMMd',
        output => 'MMM d',
    ),
    'MMMd format for fr_FR' => build_test(
        locale => 'fr_FR',
        format => 'MMMd',
        output => 'd MMM',
    ),
    # Invalid locale
    'MMMd format for fribble' => undef,
);

done_testing;
