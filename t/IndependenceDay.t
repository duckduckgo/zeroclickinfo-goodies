#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use Locale::Country;

zci answer_type => "independence_day";
zci is_cached   => 1;

sub answer {
    my $prolog;
    $prolog = "Independence Day of " . $_[0] . " " . $_[1];
    test_zci($prolog, structured_answer => {
        data => {
            country_code => country2code($_[0]),
            title => $_[1],
            subtitle => "Independence Day of " . $_[0]
        },
        templates => {
            group => "icon",
            item => "0",
            variants => {
              iconTitle => 'large',
              iconImage => 'large'
            }
        }
    });
}

ddg_goodie_test(
    [qw(DDG::Goodie::IndependenceDay)],
    "what is the independence day of norway" => answer("Norway", "May 17th, 1814"),
    "independence day, papua new guinea" => answer("Papua New Guinea", "September 16th, 1975"),
    "what is the independence day of norway?" => answer("Norway", "May 17th, 1814"),
    "when is the independence day of republic of congo" => answer("Republic of the Congo", "August 15th, 1960"),
    "when is the independence day of republic of the congo" => answer("Republic of the Congo", "August 15th, 1960"),
    "gambia independence day" => answer("The Gambia", "February 18th, 1965"),
    "the gambia independence day" => answer("The Gambia", "February 18th, 1965"),
    "usa independence day" => answer("United States of America", "July 4th, 1776"),
    "independence day of panama" => answer("Panama", "November 28th, 1821 and November 3rd, 1903"),
    "Independence Day of Armenia" => answer("Armenia", "May 28th, 1918 and September 21th, 1991"),
    "independence day of papua new guinea" => answer("Papua New Guinea", "September 16th, 1975"),
    "day of independence of sri lanka" => answer("Sri Lanka", "February 4th, 1948"),
    "when is the independence day of norway" => answer("Norway", "May 17th, 1814"),
    "day of independence, norway" => answer("Norway", "May 17th, 1814"),
    "norway independence day" => answer("Norway", "May 17th, 1814"),
    "what day is the independence day of norway" => answer("Norway", "May 17th, 1814"),
    "day of independence of bhutan" => answer("Bhutan", "December 17th, 1907")
);

done_testing;
