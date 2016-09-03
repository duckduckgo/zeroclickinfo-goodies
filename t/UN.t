#!/usr/bin/env perl
use utf8;
use strict;
use warnings;

use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'united_nations';
zci is_cached => 1;

sub build_structure
{
    my ($num, $result, $link) = @_;
    return $result, structured_answer => {
        data => {
            title => "UN Number: " . $num,
            description => $result
        },
        meta => {
            sourceName => "Wikipedia",
            sourceUrl => $link
        },
        templates => {
            group => 'info',
            options => {
                moreAt => 1
            }
        }
    };
}

ddg_goodie_test(
    [qw(DDG::Goodie::UN)],
    "un 9" => test_zci(
        build_structure(
            "0009",
            "Ammunition, incendiary with or without burster, expelling charge, or propelling charge",
            "https://en.wikipedia.org/wiki/List_of_UN_numbers_0001_to_0100"
        )
    ),
    "un number 9" => test_zci(
        build_structure(
            "0009",
            "Ammunition, incendiary with or without burster, expelling charge, or propelling charge",
            "https://en.wikipedia.org/wiki/List_of_UN_numbers_0001_to_0100"
        )
    ),
    "un number 0009" => test_zci(
        build_structure(
            "0009",
            "Ammunition, incendiary with or without burster, expelling charge, or propelling charge",
            "https://en.wikipedia.org/wiki/List_of_UN_numbers_0001_to_0100"
        )
    ),
    "un 1993" => test_zci(
        build_structure(
            "1993",
            "Combustible liquids, n.o.s",
            "https://en.wikipedia.org/wiki/List_of_UN_numbers_1901_to_2000"
        )
    ),
    "un number foo" => undef,
);

done_testing;
