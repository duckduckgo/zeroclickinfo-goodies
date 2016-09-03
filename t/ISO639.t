#!/usr/bin/env perl

use utf8;
use strict;
use warnings;

use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "iso639";
zci is_cached => 1;

sub build_test
{
    my ($text, $input, $answer) =  @_;
    return test_zci($text, structured_answer => {
        data => {
            title => $answer,
            subtitle => "ISO 639 Language code: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    ["DDG::Goodie::ISO639"],
    "iso639 ab" => build_test(qq(ISO 639: Abkhazian - ab), 'Abkhazian', 'ab'),
    "iso639 english" => build_test(qq(ISO 639: English - en), 'English','en'),
    "iso639 eng" => build_test(qq(ISO 639: English - en), 'English', 'en'),
    "iso-639 en" => build_test(qq(ISO 639: English - en), 'English', 'en'),
    "language code french" => build_test(qq(ISO 639: French - fr),'French', 'fr'),
    "iso639 xyz" => undef,
);

done_testing;
