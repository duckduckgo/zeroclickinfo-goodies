#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'currency_in';
zci is_cached => 1;

sub build_structure
{
    my ($country, $data, $type) = @_;
    if($type eq "multiple") {
        return $data, structured_answer => {
            id => "currency_in",
            name => "CurrencyIn",
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
            "Australian dollar (AUD)",
            "single"
        )
    ),
    "currency in AU" => test_zci(
        build_structure(
            "Australia",
            "Australian dollar (AUD)",
            "single"
        )
    ),
    "currency in poland" => test_zci(
        build_structure(
            "Poland",
            "Polish z\x{0142}oty (PLN)",
            "single"
        )
    ),
    "currency in Alderney" => test_zci(
        build_structure(
            "Alderney",
            {
                "Non ISO 4217" => "Alderney pound",
                "GGP" => "Guernsey pound",
                "GBP" => "British pound"
            },
            "multiple"
        )
    ),
    "currency in zw" => test_zci(
        build_structure(
            "Zimbabwe",
            {
                "BWP" => "Botswana pula",
                "EUR" => "Euro",
                "ZWL" => "Zimbabwean dollar",
                "ZAR" => "South African rand",
                "USD" => "United States dollar",
                "GBP" => "British pound",
            },
            "multiple"
        )
    )
);

done_testing;
