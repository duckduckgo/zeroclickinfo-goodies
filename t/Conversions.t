#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'conversions';
zci is_cached   => 1;

sub make_answer(%){
    my ($input) = @_;

    return {
        data => {
            raw_input         => $input->{'raw_input'},
            left_unit         => $input->{'from_unit'},
            right_unit        => $input->{'to_unit'},
            physical_quantity => $input->{'physical_quantity'}
        },
        templates => {
            group => 'base',
            options => {
                content => 'DDH.conversions.content',
            }
        }
    };
}

sub make_answer_with_base(%){
    my ($input) = @_;

    return {
        data => {
            physical_quantity => $input->{'physical_quantity'}
        },
        templates => {
            group => 'base',
            options => {
                content => 'DDH.conversions.content'
            }
        }
    };
}


ddg_goodie_test(
    ['DDG::Goodie::Conversions'],

    # Example queries
    'convert 5 oz to grams' => test_zci(
        '',
        structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'ounce',
            to_unit => 'gram',
            physical_quantity => 'mass'
        })
    ),
    'CONVERT 5 oz TO grams' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'ounce',
            to_unit => 'gram',
            physical_quantity => 'mass'
        })
    ),
    '5 ounces to grams' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'ounce',
            to_unit => 'gram',
            physical_quantity => 'mass'
        })
    ),

    # Explicit conversion requests
    # MASS
    'convert 158 ounce to lbm' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '158',
            from_unit => 'ounce',
            to_unit => 'poundmass',
            physical_quantity => 'mass'
        })
    ),
    'convert 0.111 stone to pound' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0.111',
            from_unit => 'stone',
            to_unit => 'poundmass',
            physical_quantity => 'mass'
        })
    ),
    'convert 1stone to lbs' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'stone',
            to_unit => 'poundmass',
            physical_quantity => 'mass'
        })
    ),
    # LENGTH
    q`5' 7" in inches` => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5.5833333333333333333333333333333333333333',
            from_unit => 'foot',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
    ),
    q`5feet 7inch in inches` => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5.5833333333333333333333333333333333333333',
            from_unit => 'foot',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
    ),
    q`5 foot 7 inches in inches` => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5.5833333333333333333333333333333333333333',
            from_unit => 'foot',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
    ),
    q`6 foot 3 inches in metres` => test_zci(
        '', structured_answer => make_answer({
            raw_input => '6.25',
            from_unit => 'foot',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    q`6 foot 3 in metres` => test_zci(
        '', structured_answer => make_answer({
            raw_input => '6.25',
            from_unit => 'foot',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    'convert 5 feet to in' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'foot',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
    ),
    q`5'7" in inches` => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5.5833333333333333333333333333333333333333',
            from_unit => 'foot',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
    ),
    'convert 25 inches into feet' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '25',
            from_unit => 'inch',
            to_unit => 'foot',
            physical_quantity => 'length'
        })
    ),
    'convert km to cm' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'kilometer',
            to_unit => 'cm',
            physical_quantity => 'length'
        })
    ),
    # TEMPERATURE
    'convert 5 kelvin to fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'kelvin',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    'convert 5 f to celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    ## with typis
    'convert 5 kelvin to farenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'kelvin',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    'convert 5 f to celcius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    'convert 50 centigrade to fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '50',
            from_unit => 'celsius',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    'convert 50 degrees centigrade to fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '50',
            from_unit => 'celsius',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    'convert 122 fahrenheit to degrees centigrade' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '122',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    ## with typos
    'convert 5 kelvin to farenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'kelvin',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    'convert 5 f to celcius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    # Implicit conversion requests
    # MASS
    '3 kilogramme to pound' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '3',
            from_unit => 'kilogram',
            to_unit => 'poundmass',
            physical_quantity => 'mass'
        })
    ),
    '1 ton to kilos' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'ton',
            to_unit => 'kilogram',
            physical_quantity => 'mass'
        })
    ),
    '1 dram in grams' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'dram',
            to_unit => 'gram',
            physical_quantity => 'mass'
        })
    ),
    '7 milligrams to micrograms' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '7',
            from_unit => 'milligram',
            to_unit => 'microgram',
            physical_quantity => 'mass'
        })
    ),
    # LENGTH
    '2 miles to km' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '2',
            from_unit => 'mile',
            to_unit => 'kilometer',
            physical_quantity => 'length'
        })
    ),
    '3 mi to km' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '3',
            from_unit => 'mile',
            to_unit => 'kilometer',
            physical_quantity => 'length'
        })
    ),
    '500 miles in metres' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '500',
            from_unit => 'mile',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    '25 cm in inches' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '25',
            from_unit => 'cm',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
    ),
    '1760 yards to miles' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1760',
            from_unit => 'yard',
            to_unit => 'mile',
            physical_quantity => 'length'
        })
    ),
    '3520yards to miles' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '3520',
            from_unit => 'yard',
            to_unit => 'mile',
            physical_quantity => 'length'
        })
    ),
    '500 nanometer to pm' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '500',
            from_unit => 'nanometer',
            to_unit => 'picometer',
            physical_quantity => 'length'
        })
    ),
    '500 nanometer to micrometer' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '500',
            from_unit => 'nanometer',
            to_unit => 'micrometer',
            physical_quantity => 'length'
        })
    ),
    'metres from 20 yards' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '20',
            from_unit => 'yard',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    'inches in 5 meters' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'meter',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
    ),
    '5 inches in meters' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'inch',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    'feet in an inches' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'inch',
            to_unit => 'foot',
            physical_quantity => 'length'
        })
    ),
    'FEET IN AN INCHES' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'inch',
            to_unit => 'foot',
            physical_quantity => 'length'
        })
    ),
    'feet in AN inch' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'inch',
            to_unit => 'foot',
            physical_quantity => 'length'
        })
    ),
    'mm in inches' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'inch',
            to_unit => 'millimeter',
            physical_quantity => 'length'
        })
    ),
    'mm in inch' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'inch',
            to_unit => 'millimeter',
            physical_quantity => 'length'
        })
    ),
    '3.5e-2 miles to inches' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '3.5*10^-2',
            from_unit => 'mile',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
    ),
    '5yrds to km' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'yard',
            to_unit => 'kilometer',
            physical_quantity => 'length'
        })
    ),
    '12" to cm' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '12',
            from_unit => 'inch',
            to_unit => 'cm',
            physical_quantity => 'length'
        })
    ),
    '20000 ångströms to cm' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '20000',
            from_unit => 'angstrom',
            to_unit => 'cm',
            physical_quantity => 'length'
        })
    ),
    '1 light-year in nanometres' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'lightyear',
            to_unit => 'nanometer',
            physical_quantity => 'length'
        })
    ),
    '0.1 astronomische einheit in kilometer' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0.1',
            from_unit => 'astronomicalunit',
            to_unit => 'kilometer',
            physical_quantity => 'length'
        })
    ),
    '12 parsecs in light years' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '12',
            from_unit => 'parsec',
            to_unit => 'lightyear',
            physical_quantity => 'length'
        })
    ),
    # TEMPERATURE
    '1 degree fahrenheit to celsius' => test_zci(
        '',
        structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '12 degrees Celsius to Fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '12',
            from_unit => 'celsius',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '1 degrees Fahrenheit to celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '0 c in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'celsius',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '234 f to c' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '234',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '234 f to kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '234',
            from_unit => 'fahrenheit',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    # FORCE
    '45 newtons to pounds force' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '45',
            from_unit => 'newton',
            to_unit => 'poundforce',
            physical_quantity => 'force'
        })
    ),
    # PRESSURE
    '0.01933677566613741911668448550544 psi in mmHg' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0.01933677566613741911668448550544',
            from_unit => 'psi',
            to_unit => 'mmHg',
            physical_quantity => 'pressure'
        })
    ),
    '1 gpa to megapascal' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'GPa',
            to_unit => 'MPa',
            physical_quantity => 'pressure'
        })
    ),
    '1 gpa to gbar' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'GPa',
            to_unit => 'Gbar',
            physical_quantity => 'pressure'
        })
    ),
    # DURATION
    '36 months to years' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '36',
            from_unit => 'month',
            to_unit => 'year',
            physical_quantity => 'duration'
        })
    ),
    '43200 seconds in hours' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '43200',
            from_unit => 'second',
            to_unit => 'hour',
            physical_quantity => 'duration'
        })
    ),
    '4 hours to minutes' => test_zci(
        '',
        structured_answer => make_answer({
            raw_input => '4',
            from_unit => 'hour',
            to_unit => 'minute',
            physical_quantity => 'duration'
        })
    ),
    '10000 minutes in microseconds' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10000',
            from_unit => 'minute',
            to_unit => 'microsecond',
            physical_quantity => 'duration'
        })
    ),
    '3 decades in years' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '3',
            from_unit => 'decade',
            to_unit => 'year',
            physical_quantity => 'duration'
        })
    ),
    '2 centuries in years' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '2',
            from_unit => 'century',
            to_unit => 'year',
            physical_quantity => 'duration'
        })
    ),
    '2 millennia in years' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '2',
            from_unit => 'millennium',
            to_unit => 'year',
            physical_quantity => 'duration'
        })
    ),
    '16 years in months' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '16',
            from_unit => 'year',
            to_unit => 'month',
            physical_quantity => 'duration'
        })
    ),
    '1 year in months' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'year',
            to_unit => 'month',
            physical_quantity => 'duration'
        })
    ),
    # ANGLE
    '180 degrees in radians' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '180',
            from_unit => 'deg',
            to_unit => 'rad',
            physical_quantity => 'angle'
        })
    ),
    '180 degrees in grads' => test_zci(
        '',
        structured_answer => make_answer({
            raw_input => '180',
            from_unit => 'deg',
            to_unit => 'grad',
            physical_quantity => 'angle'
        })
    ),
    # AREAS & VOLUME
    '0.001 litres in millilitres' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0.001',
            from_unit => 'litre',
            to_unit => 'millilitre',
            physical_quantity => 'volume'
        })
    ),
    # Question-style
    'what is 1 inch in cm' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'inch',
            to_unit => 'cm',
            physical_quantity => 'length'
        })
    ),
    'what are 10 yards in metres' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'yard',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    'how long is 42 days in mins' => test_zci(
        '',
        structured_answer => make_answer({
            raw_input => '42',
            from_unit => 'day',
            to_unit => 'minute',
            physical_quantity => 'duration'
        })
    ),
    'how much is 40 kelvin in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '40',
            from_unit => 'kelvin',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    'how much is 40 kelvin in celsius?' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '40',
            from_unit => 'kelvin',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    'how many metres in 10 of yard?' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'yard',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    'how many metres in 10 yards?' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'yard',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    'how many metres are in 10 yards?' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'yard',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    'how many metres are there in a mile?' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'mile',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    'how many cm in a metre?' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'meter',
            to_unit => 'cm',
            physical_quantity => 'length'
        })
    ),
    'how many cm in metres?' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'meter',
            to_unit => 'cm',
            physical_quantity => 'length'
        })
    ),
    'how many cm in an inch?' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'inch',
            to_unit => 'cm',
            physical_quantity => 'length'
        })
    ),
    'number of cm in 100 m' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '100',
            from_unit => 'meter',
            to_unit => 'cm',
            physical_quantity => 'length'
        })
    ),
    '-40 fahrenheit in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-40',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '-40 celsius in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-40',
            from_unit => 'celsius',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),

    ## Full suite of tests around temperatures
    # for computational accuracy rather than
    # parsing accuracy
    '10 fahrenheit in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'fahrenheit',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '10 celsius in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'celsius',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '10 kelvin in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'kelvin',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '10 rankine in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'rankine',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '1234 fahrenheit in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'fahrenheit',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '1234 celsius in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'celsius',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '1234 kelvin in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'kelvin',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '1234 rankine in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'rankine',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '-87 celsius in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-87',
            from_unit => 'celsius',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '-87 kelvin in fahrenheit' => undef,
    '-87 rankine in fahrenheit' => undef,
    '-7 fahrenheit in fahrenheit' => test_zci(
        '',
        structured_answer => make_answer({
            raw_input => '-7',
            from_unit => 'fahrenheit',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '-7 celsius in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-7',
            from_unit => 'celsius',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '-7 kelvin in fahrenheit' => undef,
    '-7 rankine in fahrenheit' => undef,

    '0 fahrenheit in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'fahrenheit',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '0 celsius in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'celsius',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '0 kelvin in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'kelvin',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '0 rankine in fahrenheit' => test_zci(
        '',
        structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'rankine',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '10 fahrenheit in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '10 celsius in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'celsius',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '10 kelvin in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'kelvin',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '10 rankine in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'rankine',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),

    '1234 fahrenheit in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '1234 celsius in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'celsius',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '1234 kelvin in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'kelvin',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '1234 rankine in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'rankine',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '-87 fahrenheit in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-87',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '-87 celsius in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-87',
            from_unit => 'celsius',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '-87 kelvin in celsius' => undef,
    '-87 rankine in celsius' => undef,
    '-7 fahrenheit in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-7',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '-7 celsius in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-7',
            from_unit => 'celsius',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '-7 kelvin in celsius' => undef,
    '-7 rankine in celsius' => undef,
    '0 fahrenheit in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '0 celsius in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'celsius',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '0 rankine in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'rankine',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '10 fahrenheit in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'fahrenheit',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '10 celsius in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'celsius',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '10 kelvin in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'kelvin',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '10 rankine in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'rankine',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '1234 fahrenheit in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'fahrenheit',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '1234 celsius in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'celsius',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '1234 kelvin in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'kelvin',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '1234 rankine in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'rankine',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '-87 fahrenheit in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-87',
            from_unit => 'fahrenheit',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '-87 celsius in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-87',
            from_unit => 'celsius',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '-87 kelvin in kelvin' => undef,
    '-87 rankine in kelvin' => undef,

    '-7 fahrenheit in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-7',
            from_unit => 'fahrenheit',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '-7 celsius in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-7',
            from_unit => 'celsius',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '-7 kelvin in kelvin' => undef,
    '-7 rankine in kelvin' => undef,
    '0 fahrenheit in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'fahrenheit',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '0 celsius in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'celsius',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '0 kelvin in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'kelvin',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),,
    '0 rankine in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'rankine',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),

    '10 fahrenheit in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'fahrenheit',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '10 celsius in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'celsius',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '10 kelvin in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'kelvin',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '10 rankine in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'rankine',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '1234 fahrenheit in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'fahrenheit',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '1234 celsius in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'celsius',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '1234 kelvin in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'kelvin',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '1234 rankine in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234',
            from_unit => 'rankine',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '-87 fahrenheit in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-87',
            from_unit => 'fahrenheit',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '-87 celsius in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-87',
            from_unit => 'celsius',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '-87 kelvin in rankine' => undef,
    '-87 rankine in rankine' => undef,
    '-7 fahrenheit in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-7',
            from_unit => 'fahrenheit',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '-7 celsius in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '-7',
            from_unit => 'celsius',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '-7 kelvin in rankine' => undef,
    '-7 rankine in rankine' => undef,
    '0 fahrenheit in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'fahrenheit',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '0 celsius in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'celsius',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '0 kelvin in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'kelvin',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '0 rankine in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0',
            from_unit => 'rankine',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),,
    '84856 fahrenheit in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'fahrenheit',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '84856 celsius in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'celsius',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '84856 kelvin in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'kelvin',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '84856 rankine in fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'rankine',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '84856 fahrenheit in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '84856 celsius in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'celsius',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '84856 kelvin in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'kelvin',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '84856 rankine in celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'rankine',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '84856 fahrenheit in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'fahrenheit',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '84856 celsius in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'celsius',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '84856 kelvin in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'kelvin',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '84856 rankine in kelvin' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'rankine',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '84856 fahrenheit in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'fahrenheit',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '84856 celsius in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'celsius',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '84856 kelvin in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'kelvin',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),
    '84856 rankine in rankine' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '84856',
            from_unit => 'rankine',
            to_unit => 'rankine',
            physical_quantity => 'temperature'
        })
    ),

    #Question format:
    'How to convert meters to inches' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'meter',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
    ),
    '250 feet to inches' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '250',
            from_unit => 'foot',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
    ),

    # Representation (scientific notation)
    '30000 km to m' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '30000',
            from_unit => 'kilometer',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),

    '3000000000000000 km to m' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '3*10^15',
            from_unit => 'kilometer',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    '3000 km to m' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '3000',
            from_unit => 'kilometer',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    '300000000000 km to m' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '3*10^11',
            from_unit => 'kilometer',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    '4e-15 km to mm' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '4*10^-15',
            from_unit => 'kilometer',
            to_unit => 'millimeter',
            physical_quantity => 'length'
        })
    ),
    '180 cm inches conversion' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '180',
            from_unit => 'cm',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
    ),
    'kg to lb conversion' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'kilogram',
            to_unit => 'poundmass',
            physical_quantity => 'mass'
        })
    ),
    '190 lb = ? kg' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '190',
            from_unit => 'poundmass',
            to_unit => 'kilogram',
            physical_quantity => 'mass'
        })
    ),

    # Flexible queries
    '190 lb = ?kg' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '190',
            from_unit => 'poundmass',
            to_unit => 'kilogram',
            physical_quantity => 'mass'
        })
    ),
    '190 lb =?kg' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '190',
            from_unit => 'poundmass',
            to_unit => 'kilogram',
            physical_quantity => 'mass'
        })
    ),
    '190lb =?kg' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '190',
            from_unit => 'poundmass',
            to_unit => 'kilogram',
            physical_quantity => 'mass'
        })
    ),
    'convert 330 centigrade to Farenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '330',
            from_unit => 'celsius',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '28 deg f to c' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '28',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '335 deg c to deg f' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '335',
            from_unit => 'celsius',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '30 cm equals how many inches' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '30',
            from_unit => 'cm',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
     ),
    '20 degrees to milliradians' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '20',
            from_unit => 'deg',
            to_unit => 'millirad',
            physical_quantity => 'angle'
        })
     ),
    '10 square yards to square-meters' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'sqyd',
            to_unit => 'm2',
            physical_quantity => 'area'
        })
     ),

    # NATURAL LANGUAGE QUERIES
    'unit converter' => test_zci(
        '',
        structured_answer => make_answer_with_base({
            physical_quantity => 'length',
        }),
    ),
    'unit conversion' => test_zci(
        '',
        structured_answer => make_answer_with_base({
            physical_quantity => 'length',
        }),
    ),
    'online converter' => test_zci(
        '',
        structured_answer => make_answer_with_base({
            physical_quantity => 'length',
        }),
    ),
    'velocity converter' => test_zci(
        '',
        structured_answer => make_answer_with_base({
            physical_quantity => 'speed',
        }),
    ),

    # INTENTIONALLY UNTRIGGERED
    '155 liters to millilitres' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '155',
            from_unit => 'litre',
            to_unit => 'millilitre',
            physical_quantity => 'volume'
        })
     ),
    '155343.1234 gallons to hectolitres' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '155343.1234',
            from_unit => 'usgallon',
            to_unit => 'hectolitre',
            physical_quantity => 'volume'
        })
     ),
    '1321.34 pints to pints' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1321.34',
            from_unit => 'pints',
            to_unit => 'pints',
            physical_quantity => 'volume'
        })
     ),
    '88 oilbarrel to minims' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '88',
            from_unit => 'oilbarrel',
            to_unit => 'minim',
            physical_quantity => 'volume'
        })
     ),
    'dl to cufts' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'decilitre',
            to_unit => 'cuft',
            physical_quantity => 'volume'
        })
     ),
    '1000 watts to kilowatts' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1000',
            from_unit => 'watt',
            to_unit => 'kilowatt',
            physical_quantity => 'power'
        })
    ),
    '1000 w to kw' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1000',
            from_unit => 'watt',
            to_unit => 'kilowatt',
            physical_quantity => 'power'
        })
    ),
    '1000 W to kW' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1000',
            from_unit => 'watt',
            to_unit => 'kilowatt',
            physical_quantity => 'power'
        })
    ),

    'fortnight to days' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'fortnight',
            to_unit => 'day',
            physical_quantity => 'duration'
        })
     ),
    '7 picoseconds to fseconds' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '7',
            from_unit => 'picosecond',
            to_unit => 'femtosecond',
            physical_quantity => 'duration'
        })
     ),
    '10 years to sidereal years' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'year',
            to_unit => 'siderealyear',
            physical_quantity => 'duration'
        })
     ),
    '10 barns to cm2' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'barn',
            to_unit => 'sqcentimeter',
            physical_quantity => 'area'
        })
     ),
    '10 are to barns' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'are',
            to_unit => 'barn',
            physical_quantity => 'area'
        })
     ),
    '5 kilonewtons to newton' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'kilonewton',
            to_unit => 'newton',
            physical_quantity => 'force'
        })
     ),
    '10 gram force to newton' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'gramforce',
            to_unit => 'newton',
            physical_quantity => 'force'
        })
     ),
    '50 ounce-force to gram force' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '50',
            from_unit => 'ounceforce',
            to_unit => 'gramforce',
            physical_quantity => 'force'
        })
     ),
    '15 kilogram-force to gram-force' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '15',
            from_unit => 'kilogramforce',
            to_unit => 'gramforce',
            physical_quantity => 'force'
        })
     ),
    '5 metric tonne force to kilogram force' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'metrictonforce',
            to_unit => 'kilogramforce',
            physical_quantity => 'force'
        })
     ),
     '10 barye to at' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'barye',
            to_unit => 'at',
            physical_quantity => 'pressure'
        })
     ),
     '100 millibar to Satm' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '100',
            from_unit => 'mbar',
            to_unit => 'Satm',
            physical_quantity => 'pressure'
        })
     ),
     '1000 cbar to Gbar' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1000',
            from_unit => 'cbar',
            to_unit => 'Gbar',
            physical_quantity => 'pressure'
        })
     ),
     '50 kbar to Megabar' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '50',
            from_unit => 'kbar',
            to_unit => 'Mbar',
            physical_quantity => 'pressure'
        })
     ),
     '1 dbar to cbar' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'dbar',
            to_unit => 'cbar',
            physical_quantity => 'pressure'
        })
),
     '10 hertz to exahertz' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'hertz',
            to_unit => 'exahertz',
            physical_quantity => 'frequency'
        })
     ),
    '109 petahertz to terahertz' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '109',
            from_unit => 'petahertz',
            to_unit => 'terahertz',
            physical_quantity => 'frequency'
        })
     ),
    '1 microhertz to gigahertz' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'microhertz',
            to_unit => 'gigahertz',
            physical_quantity => 'frequency'
        })
     ),
    'hertz to hertz' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'hertz',
            to_unit => 'hertz',
            physical_quantity => 'frequency'
        })
     ),
    # energe tests
    '10 electronvolts to foot pounds' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'electronvolt',
            to_unit => 'footpound',
            physical_quantity => 'energy'
        })
     ),
    '10 decielectronvolt to centielectronvolts' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'decielectronvolt',
            to_unit => 'centielectronvolt',
            physical_quantity => 'energy'
        })
     ),
    '10 millielectronvolts to microelectronvolts' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'millielectronvolt',
            to_unit => 'microelectronvolt',
            physical_quantity => 'energy'
        })
     ),
    '10 nanoelectronvolts to picoelectronvolts' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'nanoelectronvolt',
            to_unit => 'picoelectronvolt',
            physical_quantity => 'energy'
        })
     ),
    '10 femtoelectronvolts to attoelectronvolts' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'femtoelectronvolt',
            to_unit => 'attoelectronvolt',
            physical_quantity => 'energy'
        })
     ),
    '10 zeptoelectronvolts to yoctoelectronvolts' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'zeptoelectronvolt',
            to_unit => 'yoctoelectronvolt',
            physical_quantity => 'energy'
        })
     ),
    '10 decaelectronvolt to hectoelectronvolt' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'decaelectronvolt',
            to_unit => 'hectoelectronvolt',
            physical_quantity => 'energy'
        })
     ),
    '10 kiloelectronvolt to megaelectronvolt' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'kiloelectronvolt',
            to_unit => 'megaelectronvolt',
            physical_quantity => 'energy'
        })
     ),
    '10 gigaelectronvolt to teraelectronvolt' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'gigaelectronvolt',
            to_unit => 'teraelectronvolt',
            physical_quantity => 'energy'
        })
     ),
    '10 petaelectronvolts to exaelectronvolts' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'petaelectronvolt',
            to_unit => 'exaelectronvolt',
            physical_quantity => 'energy'
        })
     ),
    '10 zettaelectronvolt to yottaelectronvolt' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'zettaelectronvolt',
            to_unit => 'yottaelectronvolt',
            physical_quantity => 'energy'
        })
     ),
    'UK litres to gallons' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'litre',
            to_unit => 'usgallon',
            physical_quantity => 'volume'
        })
     ),
    '10ug to mg' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'microgram',
            to_unit => 'milligram',
            physical_quantity => 'mass'
        })
     ),
    '1234123ug to mg converter' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1234123',
            from_unit => 'microgram',
            to_unit => 'milligram',
            physical_quantity => 'mass'
        })
     ),
    '6 calorie equals how many joule' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '6',
            from_unit => 'gramcalorie',
            to_unit => 'joule',
            physical_quantity => 'energy'
        })
     ),
     '6 kj equals how many joule' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '6',
            from_unit => 'kilojoule',
            to_unit => 'joule',
            physical_quantity => 'energy'
        })
    ),
    '88 l = ml' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '88',
            from_unit => 'litre',
            to_unit => 'millilitre',
            physical_quantity => 'volume'
        })
    ),
    'weeks = 3 months' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '3',
            from_unit => 'month',
            to_unit => 'week',
            physical_quantity => 'duration'
        })
    ),
    '88.7 ml equals litres' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '88.7',
            from_unit => 'millilitre',
            to_unit => 'litre',
            physical_quantity => 'volume'
        })
     ),
    '36.0c is what in f' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '36.0',
            from_unit => 'celsius',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
     ),
    'celsius vs fahrenheit' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
     ),
    'ci to cc' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'cuin',
            to_unit => 'cc',
            physical_quantity => 'volume'
        })
     ),
    'liters per gallon' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'usgallon',
            to_unit => 'litre',
            physical_quantity => 'volume'
        })
    ),
    'liters per 100 gallon' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '100',
            from_unit => 'usgallon',
            to_unit => 'litre',
            physical_quantity => 'volume'
        })
    ),
    '100 liters per gallon' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '100',
            from_unit => 'litre',
            to_unit => 'usgallon',
            physical_quantity => 'volume'
        })
    ),
    'conversion meters to inches' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'meter',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
    ),
    'meters to inches conversion' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'meter',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
    ),
    '5.1 feet convert to meters' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5.1',
            from_unit => 'foot',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    '12888 minutes converted to hours' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '12888',
            from_unit => 'minute',
            to_unit => 'hour',
            physical_quantity => 'duration'
        })
    ),
    '100 miles convert kilometers' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '100',
            from_unit => 'mile',
            to_unit => 'kilometer',
            physical_quantity => 'length'
        })
    ),
    'miles convert 100 kilometers' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '100',
            from_unit => 'kilometer',
            to_unit => 'mile',
            physical_quantity => 'length'
        })
    ),
    'ci to cc calculator' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'cuin',
            to_unit => 'cc',
            physical_quantity => 'volume'
        })
    ),
    'yard to meters calculator' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'yard',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    'how many cms equal an inch' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'inch',
            to_unit => 'cm',
            physical_quantity => 'length'
        })
    ),
    'how many hours are in a week' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'week',
            to_unit => 'hour',
            physical_quantity => 'duration'
        })
    ),
    'how many cm make a meter' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'meter',
            to_unit => 'cm',
            physical_quantity => 'length'
        })
    ),
    '1 ounce to gram' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'ounce',
            to_unit => 'gram',
            physical_quantity => 'mass'
        })
    ),
    # speed trigger testing
    '10 mph to Feet per s' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'mi/h',
            to_unit => 'ft/s',
            physical_quantity => 'speed'
        })
    ),
    '88.8 kmh to kn' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '88.8',
            from_unit => 'km/h',
            to_unit => 'knot',
            physical_quantity => 'speed'
        })
    ),
    '88.8 kmh to mps' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '88.8',
            from_unit => 'km/h',
            to_unit => 'm/s',
            physical_quantity => 'speed'
        })
    ),

    # No right (to) unit specified. This is rectified in the backend
    '1 gram' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'gram',
            to_unit => '',
            physical_quantity => 'mass'
        })
    ),
    '1 megahertz' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'megahertz',
            to_unit => '',
            physical_quantity => 'frequency'
        })
    ),
    '1888 s' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1888',
            from_unit => 'second',
            to_unit => '',
            physical_quantity => 'duration'
        })
    ),
    '10 tablespoons to us tablespoons' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'imptbsp',
            to_unit => 'ustbsp',
            physical_quantity => 'volume'
        })
    ),
    'tablespoon to teaspoon' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'ustbsp',
            to_unit => 'ustsp',
            physical_quantity => 'volume'
        })
    ),
    '5 cups to us tablespoon' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'uscup',
            to_unit => 'ustbsp',
            physical_quantity => 'volume'
        })
    ),
    # Ounce / Fluid Ounce Ambiguity
    'how many ounces in a quart' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'usquart',
            to_unit => 'impfluidounce',
            physical_quantity => 'volume'
        })
    ),
    'ounces in a cup' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'uscup',
            to_unit => 'impfluidounce',
            physical_quantity => 'volume'
        })
    ),
    'ml to oz' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'millilitre',
            to_unit => 'impfluidounce',
            physical_quantity => 'volume'
        })
    ),
    'oz = ml' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'impfluidounce',
            to_unit => 'millilitre',
            physical_quantity => 'volume'
        })
    ),
    '1/3 cups in deciliters' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0.3333',
            from_unit => 'uscup',
            to_unit => 'decilitre',
            physical_quantity => 'volume'
        })
    ),
    'miles to nautical' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'mile',
            to_unit => 'nauticalmile',
            physical_quantity => 'length'
        })
    ),

    # single unit queries with no number
    'grams' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'gram',
            to_unit => '',
            physical_quantity => 'mass'
        })
    ),
    'meters' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'meter',
            to_unit => '',
            physical_quantity => 'length'
        })
    ),
    'feet' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'foot',
            to_unit => '',
            physical_quantity => 'length'
        })
    ),
    'petabyte' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'PB',
            to_unit => '',
            physical_quantity => 'digital'
        })
    ),
    'miles ph' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'mi/h',
            to_unit => '',
            physical_quantity => 'speed'
        })
    ),
    'gigabytes' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'GB',
            to_unit => '',
            physical_quantity => 'digital'
        })
    ),
    'miles calculator' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'mile',
            to_unit => '',
            physical_quantity => 'length'
        })
    ),
    'km converter' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'kilometer',
            to_unit => '',
            physical_quantity => 'length'
        })
    ),
    'erg calc' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'ergfixed',
            to_unit => '',
            physical_quantity => 'energy'
        })
    ),
    'grams convertisseur' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'gram',
            to_unit => '',
            physical_quantity => 'mass'
        })
    ),
    'fluid ounces to milliliters' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'usfluidounce',
            to_unit => 'millilitre',
            physical_quantity => 'volume'
        })
    ),
    'cm unit converter' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'cm',
            to_unit => '',
            physical_quantity => 'length'
        })
    ),
    'mm unit conversion' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'millimeter',
            to_unit => '',
            physical_quantity => 'length'
        })
    ),
    'unit converter kj' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'kilojoule',
            to_unit => '',
            physical_quantity => 'energy'
        })
    ),


    # abbreviations allowed though
    'cm' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'cm',
            to_unit => '',
            physical_quantity => 'length'
        })
    ),
    'mm' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'millimeter',
            to_unit => '',
            physical_quantity => 'length'
        })
    ),
    'kj' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'kilojoule',
            to_unit => '',
            physical_quantity => 'energy'
        })
    ),
    'lbs' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'poundmass',
            to_unit => '',
            physical_quantity => 'mass'
        })
    ),
    'psi' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'psi',
            to_unit => '',
            physical_quantity => 'pressure'
        })
    ),
    'km' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'kilometer',
            to_unit => '',
            physical_quantity => 'length'
        })
    ),
    'mb' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'MB',
            to_unit => '',
            physical_quantity => 'digital'
        })
    ),
    'gb' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'GB',
            to_unit => '',
            physical_quantity => 'digital'
        })
    ),
    'btu' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'BTU',
            to_unit => '',
            physical_quantity => 'energy'
        })
    ),
    'yd' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'yard',
            to_unit => '',
            physical_quantity => 'length'
        })
    ),
    'ghz' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'gigahertz',
            to_unit => '',
            physical_quantity => 'frequency'
        })
    ),
    'kg' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'kilogram',
            to_unit => '',
            physical_quantity => 'mass'
        })
    ),
    'kgs' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'kilogram',
            to_unit => '',
            physical_quantity => 'mass'
        })
    ),
    'how many inches is 120mm' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '120',
            from_unit => 'millimeter',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
    ),
    'millimeters in to inches' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'millimeter',
            to_unit => 'inch',
            physical_quantity => 'length'
        })
    ),
    'how many years is 3150000 minutes' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '3150000',
            from_unit => 'minute',
            to_unit => 'year',
            physical_quantity => 'duration'
        })
    ),
    'centigrade to fahrenheit conversion table' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'celsius',
            to_unit => 'fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    # fraction type conversions
    '1/3 m to cm' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0.3333',
            from_unit => 'meter',
            to_unit => 'cm',
            physical_quantity => 'length'
        })
    ),
    '1/3 m to cm' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0.3333',
            from_unit => 'meter',
            to_unit => 'cm',
            physical_quantity => 'length'
        })
    ),
    '1/2 byte in bits' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0.5',
            from_unit => 'B',
            to_unit => 'b',
            physical_quantity => 'digital'
        })
    ),

    # data transfer rate
    'bits per second' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'bitps',
            to_unit => '',
            physical_quantity => 'data_transfer'
        })
    ),
    'bits per second to kilobits per second' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'bitps',
            to_unit => 'kbitps',
            physical_quantity => 'data_transfer'
        })
    ),
    'bits per second to megabits per second' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'bitps',
            to_unit => 'mbitps',
            physical_quantity => 'data_transfer'
        })
    ),
    'bits per second to gigabits per second' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'bitps',
            to_unit => 'gbitps',
            physical_quantity => 'data_transfer'
        })
    ),
    'bits per second to terrabits per second' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'bitps',
            to_unit => 'tbitps',
            physical_quantity => 'data_transfer'
        })
    ),
    'bits per second to terabytes per second' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'bitps',
            to_unit => 'terabyteps',
            physical_quantity => 'data_transfer'
        })
    ),
    '4" to cms' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '4',
            from_unit => 'inch',
            to_unit => 'cm',
            physical_quantity => 'length'
        })
    ),
    '0.1 µm in mil' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '0.1',
            from_unit => 'micrometer',
            to_unit => 'millimeter',
            physical_quantity => 'length'
        })
    ),
    '1 kilogram = ? decagram' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'kilogram',
            to_unit => 'dekagram',
            physical_quantity => 'mass'
        })
    ),
    '9 GiB to kilobytes' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '9',
            from_unit => 'gibibyte',
            to_unit => 'KB',
            physical_quantity => 'digital'
        })
    ),
    '35 cm equals what in m' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '35',
            from_unit => 'cm',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),
    '450 degrees to celsius' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '450',
            from_unit => 'fahrenheit',
            to_unit => 'celsius',
            physical_quantity => 'temperature'
        })
    ),
    '5 cm ?= m' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'cm',
            to_unit => 'meter',
            physical_quantity => 'length'
        })
    ),

    # case sensitivity
    '1 Gb to GB' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'gbit',
            to_unit => 'GB',
            physical_quantity => 'digital'
        })
    ),
    '1 GB to Gb' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'GB',
            to_unit => 'gbit',
            physical_quantity => 'digital'
        })
    ),
    '1 gb to Gb' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'GB',
            to_unit => 'gbit',
            physical_quantity => 'digital'
        })
    ),
    '1 bytes to TiB' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'B',
            to_unit => 'tebibyte',
            physical_quantity => 'digital'
        })
    ),
    '1 bytes to tib' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'B',
            to_unit => 'tebibyte',
            physical_quantity => 'digital'
        })
    ),
    '10 bytes to Ti' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '10',
            from_unit => 'B',
            to_unit => 'tebibit',
            physical_quantity => 'digital'
        })
    ),
    'nanometer to micron' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'nanometer',
            to_unit => 'micrometer',
            physical_quantity => 'length'
        })
    ),
    'nanometer to micron' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'nanometer',
            to_unit => 'micrometer',
            physical_quantity => 'length'
        })
    ),
    'nanometer to μm ' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'nanometer',
            to_unit => 'micrometer',
            physical_quantity => 'length'
        })
    ),
    'seconds to μs' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'second',
            to_unit => 'microsecond',
            physical_quantity => 'duration'
        })
    ),
    'grams to μg' => test_zci(
        '', structured_answer => make_answer({
            raw_input => '1',
            from_unit => 'gram',
            to_unit => 'microgram',
            physical_quantity => 'mass'
        })
    ),

    # natural language queries
    'unit converter' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'length',
        }),
     ),
    'unit conversion' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'length',
        }),
     ),
    'online converter' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'length',
        }),
     ),
    # natural language queries containing triggers
    'volume converter' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'volume'
        })
     ),
    'mass conversion' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'mass'
        })
     ),
    'duration converter' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'duration'
        })
     ),
    'force conversion' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'force'
        })
     ),
    'pressure converter' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'pressure'
        })
     ),
    'speed conversion' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'speed'
        })
     ),
    'speed calculator' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'speed'
        })
     ),
    'temperature conversion' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'temperature'
        })
     ),
    'area converter' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'area'
        })
     ),
    'angle conversion' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'angle'
        })
     ),
    'conversion calculator' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'length'
        })
     ),
    'metric conversion calculator' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'length'
        })
     ),
    'measurement conversion chart' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'length'
        })
     ),
    'conversion calculator' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'length'
        })
     ),
    # spanish word for converter
    'convertidor' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'length'
        })
     ),
    'conversion' => test_zci(
        '', structured_answer => make_answer_with_base({
            physical_quantity => 'length'
        })
     ),

    # Intentionally untriggered
    'BTU to KwH'                      => undef,
    '5 inches in 5 meters'            => undef,
    'convert 1 cm to 2 mm'            => undef,
    'inching towards the goal'        => undef,
    '6^2 oz to grams'                 => undef,
    'NaN oz to stones'                => undef,
    '45x10 oz to stones'              => undef,
    'convert -9 g to ozs'             => undef,
    'convert 5 oz to yards'           => undef,
    'puff toke to kludge'             => undef,
    'Inf oz to stones'                => undef,
    'convert -5 kelvin to fahrenheit' => undef,
    'use a ton of stones'             => undef,
    'shoot onself in the foot'        => undef,
    'foot in both camps'              => undef,
    '1E300 miles in metres'           => undef,
    '5 pas.i to atm'                  => undef,
    'grams of ham'                    => undef,
    'car was going 100 mph'           => undef,
    'length'                          => undef,
    'speed'                           => undef,

    # don't trigger on units where the string is <= 3
    'cms'                             => undef,
    'mph'                             => undef,
    'ft'                              => undef,
    'gs'                              => undef,
    'ms'                              => undef,
);
done_testing;
