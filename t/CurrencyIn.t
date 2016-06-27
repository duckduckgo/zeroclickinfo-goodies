#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'currency_in';
zci is_cached => 1;

sub build_structure
{
    my ($country, $data, $type) = @_;
    if($type eq "multiple") {
        return $data, structured_answer => {
            templates => {
                group => 'list',
                options => {
                    content => 'record',
                    moreAt => 0
                }
            },
            data => {
                title => "Currencies in $country",
                record_data => $data
            }
        };
    } else {
        return $data, structured_answer => {
            input     => [$country],
            operation => "Currency in",
            result    => $data
        };
    }
}

ddg_goodie_test(
    [qw(DDG::Goodie::CurrencyIn)],
    "currency in australia" => test_zci(
        build_structure(
            "Australia",
            "Australian Dollar (AUD)",
            "single"
        )
    ),
    "currency in AU" => test_zci(
        build_structure(
            "Australia",
            "Australian Dollar (AUD)",
            "single"
        )
    ),
    "currency in poland" => test_zci(
        build_structure(
            "Poland",
            "Polish Z\x{0142}oty (PLN)",
            "single"
        )
    ),
    "currency in Alderney" => test_zci(
        build_structure(
            "Alderney",
            {
                "NON ISO 4217" => "Alderney Pound",
                "GGP" => "Guernsey Pound",
                "GBP" => "British Pound"
            },
            "multiple"
        )
    ),
    "currency in zw" => test_zci(
        build_structure(
            "Zimbabwe",
            {
                "BWP" => "Botswana Pula",
                "EUR" => "Euro",
                "ZWL" => "Zimbabwean Dollar",
                "ZAR" => "South African Rand",
                "USD" => "United States Dollar",
                "GBP" => "British Pound",
            },
            "multiple"
        )
    )
);

done_testing;
