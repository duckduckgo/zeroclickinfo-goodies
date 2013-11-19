#!/usr/bin/env perl
use utf8;
use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Locale::Codes

zci is_cached => 1;

ddg_goodie_test(
    ["DDG::Goodie::ISO639"],
    "iso639 ab" => test_zci(
        qq(ISO 639: Abkhazian - ab),
        html        => qq(<a href="https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes">ISO 639</a>: Abkhazian - ab),
        answer_type => "iso639"
    ),
    "iso639 english" => test_zci(
        qq(ISO 639: English - en),
        html        => qq(<a href="https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes">ISO 639</a>: English - en),
        answer_type => "iso639"
    ),
    "iso639 eng" => test_zci(
        qq(ISO 639: English - en),
        html        => qq(<a href="https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes">ISO 639</a>: English - en),
        answer_type => "iso639"
    ),
    "iso-639 en" => test_zci(
        qq(ISO 639: English - en),
        html        => qq(<a href="https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes">ISO 639</a>: English - en),
        answer_type => "iso639"
    ),
    "iso639 xyz" => undef,
    );

done_testing;
