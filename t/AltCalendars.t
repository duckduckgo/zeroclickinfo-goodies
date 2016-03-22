#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
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
);

ddg_goodie_test(
    [qw( DDG::Goodie::AltCalendars )],
    'heisei 25' => test_zci(
        'Heisei 25 is equivalent to 2013 in the Gregorian Calendar',
        make_structured_answer('Heisei', '25', '2013')
    ),
    'shouwa 39' => test_zci(
        'Shouwa 39 is equivalent to 1964 in the Gregorian Calendar',
        make_structured_answer('Shouwa', '39', '1964')
    ),
    'taisho 11' => test_zci(
        'Taisho 11 is equivalent to 1922 in the Gregorian Calendar',
        make_structured_answer('Taisho', '11', '1922')
    ),
    'meiji 1' => test_zci(
        'Meiji 1 is equivalent to 1868 in the Gregorian Calendar',
        make_structured_answer('Meiji', '1', '1868')
    ),
    'minguo 50' => test_zci(
        'Minguo 50 is equivalent to 1961 in the Gregorian Calendar',
        make_structured_answer('Minguo', '50', '1961')
    ),
    'juche 07' => test_zci(
        'Juche 07 is equivalent to 1918 in the Gregorian Calendar',
        make_structured_answer('Juche', '07', '1918')
    ),
    'Heisei 12 was a leap year' => test_zci(
        'Heisei 12 is equivalent to 2000 in the Gregorian Calendar',
        make_structured_answer('Heisei', '12', '2000')
    ),
    'it\'s heisei 25 now' => test_zci(
        'Heisei 25 is equivalent to 2013 in the Gregorian Calendar',
        make_structured_answer('Heisei', '25', '2013')
    ),
    'January 1st Meiji 33' => test_zci(
        'Meiji 33 is equivalent to 1900 in the Gregorian Calendar',
        make_structured_answer('Meiji', '33', '1900')
    ),
    'heisei 24' => test_zci(
        'Heisei 24 is equivalent to 2012 in the Gregorian Calendar',
        make_structured_answer('Heisei', '24', '2012')
    )
);

sub make_structured_answer {
    my ($era_name, $era_year, $gregorian_year) = @_;

    return structured_answer => {
        id => 'altcalendars',
        name => 'Answer',
        data => {
            title => $gregorian_year,
            subtitle => "$era_name $era_year - Equivalent Gregorian Year"
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
