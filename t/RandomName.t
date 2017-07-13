#! /usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci is_cached => 0;
zci answer_type => "randomname";

sub build_name_answer {
    my @test_params = @_;

    return re(qr/\w\w/),
        structured_answer => {
            data => {
                title => re(qr/\w\w/),
                altSubtitle => re(qr/Randomly generated name/)
            },

            templates => {
                group => "icon",
            }
        };
}

sub build_person_answer {
    my @test_params = @_;

    return re(qr/Name: [\w\s]+\nGender: (?:Male|Female)\nDate of birth: \d{4}\-\d{2}\-\d{2}\nAge: \d+/),
        structured_answer => {
            data => {
                title => re(qr/\w\w/),
                subtitle => re(qr/Birthday: \d{4}\-\d{2}\-\d{2}\+ | Age: \d/),
                altSubtitle => re(qr/Randomly generated person/)
            },

            templates => {
                group => "icon",
            }
        };
}

sub build_name_test { test_zci(build_name_answer(@_)) }
sub build_person_test { test_zci(build_person_answer(@_)) }

ddg_goodie_test(
    [
        'DDG::Goodie::RandomName'
    ],
    'random name' => build_name_test(),
    'random Name' => build_name_test(),
    'random person' => build_person_test(),
    'random Person' => build_person_test(),
    'random domain name' => undef,
    'random city name' => undef,
    'names of random people' => undef
);

done_testing;
