#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'date_conversion';
zci is_cached => 1;

my %eras = (
    'Meiji'   => 'Meiji_period',
    'Taisho'  => 'Taisho_period',
    'Taishou' => 'Taisho_period',
    'Showa'   => 'Showa_period',
    'Shouwa'  => 'Showa_period',
    'Heisei'  => 'Heisei_period',
    'Juche'   => 'North_Korean_calendar',
    'Minguo'  => 'Minguo_calendar',
    'Discordian' => 'Discordian_calendar',
    'Suriyakhati' => 'Thai_solar_calendar'
);

ddg_goodie_test(
    [qw( DDG::Goodie::AltCalendars )],
    'heisei 25' => test_zci(
        'Heisei 25 is equivalent to 2013 AD in the Gregorian Calendar',
        make_structured_answer('Heisei', '25', '2013', 'AD')
    ),
    'shouwa 39' => test_zci(
        'Shouwa 39 is equivalent to 1964 AD in the Gregorian Calendar',
        make_structured_answer('Shouwa', '39', '1964', 'AD')
    ),
    'taisho 11' => test_zci(
        'Taisho 11 is equivalent to 1922 AD in the Gregorian Calendar',
        make_structured_answer('Taisho', '11', '1922', 'AD')
    ),
    'meiji 1' => test_zci(
        'Meiji 1 is equivalent to 1868 AD in the Gregorian Calendar',
        make_structured_answer('Meiji', '1', '1868', 'AD')
    ),
    'minguo 50' => test_zci(
        'Minguo 50 is equivalent to 1961 AD in the Gregorian Calendar',
        make_structured_answer('Minguo', '50', '1961', 'AD')
    ),
    'juche 07' => test_zci(
        'Juche 07 is equivalent to 1918 AD in the Gregorian Calendar',
        make_structured_answer('Juche', '07', '1918', 'AD')
    ),
    'heisei 24' => test_zci(
        'Heisei 24 is equivalent to 2012 AD in the Gregorian Calendar',
        make_structured_answer('Heisei', '24', '2012', 'AD')
    ),
    'suriyakhati 543' => test_zci(
        'Suriyakhati 543 is equivalent to 0 BC in the Gregorian Calendar',
        make_structured_answer('Suriyakhati', '543', '0', 'BC')
    ),
    'suriyakhati 43' => test_zci(
        'Suriyakhati 43 is equivalent to 500 BC in the Gregorian Calendar',
        make_structured_answer('Suriyakhati', '43', '500', 'BC')
    ),
    'was Heisei 12 was a leap year' => undef,
    'it\'s heisei 25 now' => undef,
    'January 1st Meiji 33' => undef,
    'when was Discordian 2000' => undef,
    'meiji 2 45645' => undef,
    'bengali calendar 423' => undef
);

sub make_structured_answer {
    my ($era_name, $era_year, $gregorian_year, $era) = @_;

    return structured_answer => {
        data => {
            title => "$gregorian_year $era",
            subtitle => "$era_name Year $era_year"
        },
         meta => {
            sourceName => "Wikipedia",
            sourceUrl => "https://en.wikipedia.org/wiki/$eras{$era_name}"
        },
        templates => {
            group => 'info',
            options => {
                moreAt => 1
            }
        }
    };
};

done_testing;
