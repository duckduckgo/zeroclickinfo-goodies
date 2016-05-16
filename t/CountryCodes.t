#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "country_codes";
zci is_cached   => 1;

sub build_structured_answer{
    my ($country, $response) = @_;
    return 'ISO 3166: '. ucfirst $country .' - '. $response,
        structured_answer => {
            data => {
                title    => $response,
                subtitle => "ISO 3166 Country code: " . ucfirst ($country),
            },
            templates => {
                group => "text",
            },
        },
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
        [ 'DDG::Goodie::CountryCodes' ],
        "country code Japan"                     => build_test("Japan","jp"),
        "3 letter country code Japan"            => build_test("Japan","jpn"),
        "3 letter country code of China"         => build_test("China","chn"),
        "Japan 3 letter country code"            => build_test("Japan","jpn"),
        "Russia two letter country code"         => build_test("Russia","ru"),
        "two letter country code Japan"          => build_test("Japan","jp"),
        "three letter country code for Japan"    => build_test("Japan","jpn"),
        "numerical iso code japan"               => build_test("Japan",392),
        "iso code for spain"                     => build_test("Spain","es"),
        "country code jp"                        => build_test("Japan","jp"),
        "japan numerical iso 3166"               => build_test("Japan",392),
        "united states of america iso code"      => build_test("United states of america","us"),
        "3 letter iso code isle of man"          => build_test("Isle of man","imn"),
        'country code for gelgamek'              => undef,
        'iso code for english'                   => undef,
);

done_testing;
