#!/usr/bin/env perl

use utf8;
use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => "iso639";
zci is_cached => 1;

ddg_goodie_test(
    ["DDG::Goodie::ISO639"],
    "iso639 ab" => test_zci(
        qq(ISO 639: Abkhazian - ab),
        structured_answer => {
            input => ['Abkhazian'],
            operation => 'ISO 639 Language code',
            result => 'ab',
        }
    ),
    "iso639 english" => test_zci(
        qq(ISO 639: English - en),
        structured_answer => {
            input => ['English'],
            operation => 'ISO 639 Language code',
            result => 'en',
        }
    ),
    "iso639 eng" => test_zci(
        qq(ISO 639: English - en),
        structured_answer => {
            input => ['English'],
            operation => 'ISO 639 Language code',
            result => 'en',
        }
    ),
    "iso-639 en" => test_zci(
        qq(ISO 639: English - en),
        structured_answer => {
            input => ['English'],
            operation => 'ISO 639 Language code',
            result => 'en',
        }
    ),
    "language code french" => test_zci(
        qq(ISO 639: French - fr),
        structured_answer => {
            input => ['French'],
            operation => 'ISO 639 Language code',
            result => 'fr',
        }
    ),
    "iso639 xyz" => undef,
);

done_testing;
