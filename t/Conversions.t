#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;
zci answer_type => 'conversions';
zci is_cached   => 1;

sub make_answer(%){
    my ($input) = @_;
    
    return {
        id   => 'conversions',
        name => 'conversions',
        data => {
            raw_input         => $input->{'raw_input'},
            raw_answer        => $input->{'raw_answer'},
            left_unit         => $input->{'from_unit'},
            right_unit        => $input->{'to_unit'},
            markup_input      => $input->{'markup_input'},
            styled_output     => $input->{'styled_output'},
            physical_quantity => $input->{'physical_quantity'}
        },
        templates => {
            group => 'text',
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
        '5 ounces = 141.747 grams',
        structured_answer => make_answer({
            raw_input => '5',
            from_unit => 'ounces',
            raw_answer => '141.747',
            to_unit => 'grams',
            markup_input => '5',
            styled_output => '141.747',
            physical_quantity => 'mass'
        })
    ),
    '5 ounces to g' => test_zci(
        '5 ounces = 141.747 grams',
        structured_answer => make_answer({
            markup_input => '5',
            raw_input => '5',
            from_unit => 'ounces',
            styled_output => '141.747',
            raw_answer => '141.747',
            to_unit => 'grams',
            physical_quantity => 'mass'
        })
    ),
    '0.5 nautical miles in km' => test_zci(
        '0.5 nautical miles = 0.926 kilometers',
        structured_answer => make_answer({
            markup_input => '0.5',
            raw_input => '0.5',
            from_unit => 'nautical miles',
            styled_output => '0.926',
            raw_answer => '0.926',
            to_unit => 'kilometers',
            physical_quantity => 'length'
        })
    ),
    # Explicit conversion requests
    'convert 1 ton to long ton' => test_zci(
        '1 ton = 0.893 long tons',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'ton',
            styled_output => '0.893',
            raw_answer => '0.893',
            to_unit => 'long tons',
            physical_quantity => 'mass'
        })
    ),
    'convert 158 ounce to lbm' => test_zci(
        '158 ounces = 9.875 pounds',
        structured_answer => make_answer({
            markup_input => '158',
            raw_input => '158',
            from_unit => 'ounces',
            styled_output => '9.875',
            raw_answer => '9.875',
            to_unit => 'pounds',
            physical_quantity => 'mass'
        })
    ),
    'convert 0.111 stone to pound' => test_zci(
        '0.111 stone = 1.554 pounds',
        structured_answer => make_answer({
            markup_input => '0.111',
            raw_input => '0.111',
            from_unit => 'stone',
            styled_output => '1.554',
            raw_answer => '1.554',
            to_unit => 'pounds',
            physical_quantity => 'mass'
        })
    ),
    'convert 5 feet to in' => test_zci(
        '5 feet = 60 inches',
        structured_answer => make_answer({
            markup_input => '5',
            raw_input => '5',
            from_unit => 'feet',
            styled_output => '60',
            raw_answer => '60',
            to_unit => 'inches',
            physical_quantity => 'length'
        })
    ),
    'convert 5 kelvin to fahrenheit' => test_zci(
        '5 kelvin = -450.670 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '5',
            raw_input => '5',
            from_unit => 'kelvin',
            styled_output => '-450.670',
            raw_answer => '-450.670',
			to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    'light year to mm' => test_zci(
        '1 light year = 9.46 * 10^18 millimeters',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'light year',
            styled_output => '9.46 * 10<sup>18</sup>',
            raw_answer => '9.46*10^18',
            to_unit => 'millimeters',
            physical_quantity => 'length'
        })
    ),
    'BTU to KwH' => test_zci(
        '1 british thermal unit = 0.000293 kilowatt-hours',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'british thermal unit',
            styled_output => '0.000293',
            raw_answer => '0.000293',
            to_unit => 'kilowatt-hours',
            physical_quantity => 'energy'
            
        })
    ),
    'convert 25 inches into feet' => test_zci(
        '25 inches = 2.083 feet',
        structured_answer => make_answer({
            markup_input => '25',
            raw_input => '25',
            from_unit => 'inches',
            styled_output => '2.083',
            raw_answer => '2.083',
            to_unit => 'feet',
            physical_quantity => 'length'
        })
    ),
    'convert 5 f to celsius' => test_zci(
        '5 degrees fahrenheit = -15 degrees celsius',
        structured_answer => make_answer({
            markup_input => '5',
            raw_input => '5',
            from_unit => 'degrees fahrenheit',
            styled_output => '-15',
            raw_answer => '-15',
			to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    'convert km to cm' => test_zci(
        '1 kilometer = 100,000 centimeters',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'kilometer',
            styled_output => '100,000',
            raw_answer => '100000',
            to_unit => 'centimeters',
            physical_quantity => 'length'
        })
    ),
    'convert 10ms to seconds' => test_zci(
        '10 milliseconds = 0.010 seconds',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'milliseconds',
            styled_output => '0.010',
            raw_answer => '0.010',
            to_unit => 'seconds',
            physical_quantity => 'duration'
        })
    ),
    'convert 1 yb to yib' => test_zci(
        '1 yottabyte = 0.827 yobibytes',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'yottabyte',
            styled_output => '0.827',
            raw_answer => '0.827',
            to_unit => 'yobibytes',
            physical_quantity => 'digital'
        })
    ),
    'convert 1stone to lbs' => test_zci(
        '1 stone = 14 pounds',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'stone',
            styled_output => '14',
            raw_answer => '14',
            to_unit => 'pounds',
            physical_quantity => 'mass'
        })
    ),
    'convert 5 bytes to bit' => test_zci(
        '5 bytes = 40 bits',
        structured_answer => make_answer({
            markup_input => '5',
            raw_input => '5',
            from_unit => 'bytes',
            styled_output => '40',
            raw_answer => '40',
            to_unit => 'bits',
            physical_quantity => 'digital'
        })
    ),
    # Implicit conversion requests
    '3 kilogramme to pound' => test_zci(
        '3 kilograms = 6.614 pounds',
        structured_answer => make_answer({
            markup_input => '3',
            raw_input => '3',
            from_unit => 'kilograms',
            styled_output => '6.614',
            raw_answer => '6.614',
            to_unit => 'pounds',
            physical_quantity => 'mass'
        })
    ),
    '1.3 tonnes to ton' => test_zci(
        '1.3 metric tons = 1.433 tons',
        structured_answer => make_answer({
            markup_input => '1.3',
            raw_input => '1.3',
            from_unit => 'metric tons',
            styled_output => '1.433',
            raw_answer => '1.433',
            to_unit => 'tons',
            physical_quantity => 'mass'
        })
    ),
    '2 tons to kg' => test_zci(
        '2 tons = 1,814.372 kilograms',
        structured_answer => make_answer({
            markup_input => '2',
            raw_input => '2',
            from_unit => 'tons',
            styled_output => '1,814.372',
            raw_answer => '1814.372',
            to_unit => 'kilograms',
            physical_quantity => 'mass'
        })
    ),
    '1 ton to kilos' => test_zci(
        '1 ton = 907.186 kilograms',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'ton',
            styled_output => '907.186',
            raw_answer => '907.186',
            to_unit => 'kilograms',
            physical_quantity => 'mass'
        })
    ),
    '3.9 oz in g' => test_zci(
        '3.9 ounces = 110.563 grams',
        structured_answer => make_answer({
            markup_input => '3.9',
            raw_input => '3.9',
            from_unit => 'ounces',
            styled_output => '110.563',
            raw_answer => '110.563',
            to_unit => 'grams',
            physical_quantity => 'mass'
        })
    ),
    '2 miles to km' => test_zci(
        '2 miles = 3.219 kilometers',
        structured_answer => make_answer({
            markup_input => '2',
            raw_input => '2',
            from_unit => 'miles',
            styled_output => '3.219',
            raw_answer => '3.219',
            to_unit => 'kilometers',
            physical_quantity => 'length'
        })
    ),
    '3 mi to km' => test_zci(
        '3 miles = 4.828 kilometers',
        structured_answer => make_answer({
            markup_input => '3',
            raw_input => '3',
            from_unit => 'miles',
            styled_output => '4.828',
            raw_answer => '4.828',
            to_unit => 'kilometers',
            physical_quantity => 'length'
        })
    ),
    '0.5 nautical mile to klick' => test_zci(
        '0.5 nautical miles = 0.926 kilometers',
        structured_answer => make_answer({
            markup_input => '0.5',
            raw_input => '0.5',
            from_unit => 'nautical miles',
            styled_output => '0.926',
            raw_answer => '0.926',
            to_unit => 'kilometers',
            physical_quantity => 'length'
        })
    ),
    '500 miles in metres' => test_zci(
        '500 miles = 804,672 meters',
        structured_answer => make_answer({
            markup_input => '500',
            raw_input => '500',
            from_unit => 'miles',
            styled_output => '804,672',
            raw_answer => '804672',
            to_unit => 'meters',
            physical_quantity => 'length'
        })
    ),
    '25 cm in inches' => test_zci(
        '25 centimeters = 9.843 inches',
        structured_answer => make_answer({
            markup_input => '25',
            raw_input => '25',
            from_unit => 'centimeters',
            styled_output => '9.843',
            raw_answer => '9.843',
            to_unit => 'inches',
            physical_quantity => 'length'
        })
    ),
    '1760 yards to miles' => test_zci(
        '1,760 yards = 1 mile',
        structured_answer => make_answer({
            markup_input => '1,760',
            raw_input => '1760',
            from_unit => 'yards',
            styled_output => '1',
            raw_answer => '1',
            to_unit => 'mile',
            physical_quantity => 'length'
        })
    ),
    '3520yards to miles' => test_zci(
        '3,520 yards = 2 miles',
        structured_answer => make_answer({
            markup_input => '3,520',
            raw_input => '3520',
            from_unit => 'yards',
            styled_output => '2',
            raw_answer => '2',
            to_unit => 'miles',
            physical_quantity => 'length'
        })
    ),
    '30cm in in' => test_zci(
        '30 centimeters = 11.811 inches',
        structured_answer => make_answer({
            markup_input => '30',
            raw_input => '30',
            from_unit => 'centimeters',
            styled_output => '11.811',
            raw_answer => '11.811',
            to_unit => 'inches',
            physical_quantity => 'length'
        })
    ),
    '36 months to years' => test_zci(
        '36 months = 3 years',
        structured_answer => make_answer({
            markup_input => '36',
            raw_input => '36',
            from_unit => 'months',
            styled_output => '3',
            raw_answer => '3',
            to_unit => 'years',
            physical_quantity => 'duration'
        })
    ),
    '43200 seconds in hours' => test_zci(
        '43,200 seconds = 12 hours',
        structured_answer => make_answer({
            markup_input => '43,200',
            raw_input => '43200',
            from_unit => 'seconds',
            styled_output => '12',
            raw_answer => '12',
            to_unit => 'hours',
            physical_quantity => 'duration'
        })
    ),
    '4 hours to minutes' => test_zci(
        '4 hours = 240 minutes',
        structured_answer => make_answer({
            markup_input => '4',
            raw_input => '4',
            from_unit => 'hours',
            styled_output => '240',
            raw_answer => '240',
            to_unit => 'minutes',
            physical_quantity => 'duration'
        })
    ),
    '1 bar to pascal' => test_zci(
        '1 bar = 100,000 pascals',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'bar',
            styled_output => '100,000',
            raw_answer => '100000',
            to_unit => 'pascals',
            physical_quantity => 'pressure'
        })
    ),
    '1 kilopascal to psi' => test_zci(
        '1 kilopascal = 0.145 pounds per square inch',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'kilopascal',
            styled_output => '0.145',
            raw_answer => '0.145',
            to_unit => 'pounds per square inch',
            physical_quantity => 'pressure'
        })
    ),
    '1 atm to kpa' => test_zci(
        '1 atmosphere = 101.325 kilopascals',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'atmosphere',
            styled_output => '101.325',
            raw_answer => '101.325',
            to_unit => 'kilopascals',
            physical_quantity => 'pressure'
        })
    ),
    '5yrds to km' => test_zci(
        '5 yards = 0.005 kilometers',
        structured_answer => make_answer({
            markup_input => '5',
            raw_input => '5',
            from_unit => 'yards',
            styled_output => '0.005',
            raw_answer => '0.005',
            to_unit => 'kilometers',
            physical_quantity => 'length'
        })
    ),
    '12" to cm' => test_zci(
        '12 inches = 30.480 centimeters',
        structured_answer => make_answer({
            markup_input => '12',
            raw_input => '12',
            from_unit => 'inches',
            styled_output => '30.480',
            raw_answer => '30.480',
            to_unit => 'centimeters',
            physical_quantity => 'length'
        })
    ),
    '42 kilowatt hours in joules' => test_zci(
        '42 kilowatt-hours = 1.51 * 10^8 joules',
        structured_answer => make_answer({
            markup_input => '42',
            raw_input => '42',
            from_unit => 'kilowatt-hours',
            styled_output => '1.51 * 10<sup>8</sup>',
            raw_answer => '1.51*10^8',
            to_unit => 'joules',
            physical_quantity => 'energy'
        })
    ),
    '2500kcal in tons of tnt' => test_zci(
        '2,500 large calories = 0.003 tons of TNT',
        structured_answer => make_answer({
            markup_input => '2,500',
            raw_input => '2500',
            from_unit => 'large calories',
            styled_output => '0.003',
            raw_answer => '0.003',
            to_unit => 'tons of TNT',
            physical_quantity => 'energy'
        })
    ),
    '90 ps in watts' => test_zci(
        '90 metric horsepower = 66,194.888 watts',
        structured_answer => make_answer({
            markup_input => '90',
            raw_input => '90',
            from_unit => 'metric horsepower',
            styled_output => '66,194.888',
            raw_answer => '66194.888',
            to_unit => 'watts',
            physical_quantity => 'power'
        })
    ),
    '1 gigawatt in horsepower' => test_zci(
        '1 gigawatt = 1.34 * 10^6 horsepower',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'gigawatt',
            styled_output => '1.34 * 10<sup>6</sup>',
            raw_answer => '1.34*10^6',
            to_unit => 'horsepower',
            physical_quantity => 'power'
        })
    ),
    '180 degrees in radians' => test_zci(
        '180 degrees = 3.142 radians',
        structured_answer => make_answer({
            markup_input => '180',
            raw_input => '180',
            from_unit => 'degrees',
            styled_output => '3.142',
            raw_answer => '3.142',
            to_unit => 'radians',
            physical_quantity => 'angle'
        })
    ),
    '270 degrees in quadrants' => test_zci(
        '270 degrees = 3 quadrants',
        structured_answer => make_answer({
            markup_input => '270',
            raw_input => '270',
            from_unit => 'degrees',
            styled_output => '3',
            raw_answer => '3',
            to_unit => 'quadrants',
            physical_quantity => 'angle'
        })
    ),
    '180 degrees in grads' => test_zci(
        '180 degrees = 200 gradians',
        structured_answer => make_answer({
            markup_input => '180',
            raw_input => '180',
            from_unit => 'degrees',
            styled_output => '200',
            raw_answer => '200',
            to_unit => 'gradians',
            physical_quantity => 'angle'
        })
    ),
    '45 newtons to pounds force' => test_zci(
        '45 newtons = 10.116 pounds force',
        structured_answer => make_answer({
            markup_input => '45',
            raw_input => '45',
            from_unit => 'newtons',
            styled_output => '10.116',
            raw_answer => '10.116',
            to_unit => 'pounds force',
            physical_quantity => 'force'
        })
    ),
    '8 poundal to newtons' => test_zci(
        '8 poundals = 1.106 newtons',
        structured_answer => make_answer({
            markup_input => '8',
            raw_input => '8',
            from_unit => 'poundals',
            styled_output => '1.106',
            raw_answer => '1.106',
            to_unit => 'newtons',
            physical_quantity => 'force'
        })
    ),
    '10 mg to tons' => test_zci(
        '10 milligrams = 1.1 * 10^-8 tons',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'milligrams',
            styled_output => '1.1 * 10<sup>-8</sup>',
            raw_answer => '1.1*10^-8',
            to_unit => 'tons',
            physical_quantity => 'mass'
        })
    ),
    '10000 minutes in microseconds' => test_zci(
        '10,000 minutes = 6 * 10^11 microseconds',
        structured_answer => make_answer({
            markup_input => '10,000',
            raw_input => '10000',
            from_unit => 'minutes',
            styled_output => '6 * 10<sup>11</sup>',
            raw_answer => '6*10^11',
            to_unit => 'microseconds',
            physical_quantity => 'duration'
        })
    ),
    '5 GB to megabyte' => test_zci(
        '5 gigabytes = 5,000 megabytes',
        structured_answer => make_answer({
            markup_input => '5',
            raw_input => '5',
            from_unit => 'gigabytes',
            styled_output => '5,000',
            raw_answer => '5000',
            to_unit => 'megabytes',
            physical_quantity => 'digital'
        })
    ),
    '0.013 mb in bits' => test_zci(
        '0.013 megabytes = 104,000 bits',
        structured_answer => make_answer({
            markup_input => '0.013',
            raw_input => '0.013',
            from_unit => 'megabytes',
            styled_output => '104,000',
            raw_answer => '104000',
            to_unit => 'bits',
            physical_quantity => 'digital'
        })
    ),
    '0,013 mb in bits' => test_zci(
        '0,013 megabytes = 104.000 bits',
        structured_answer => make_answer({
            markup_input => '0,013',
            raw_input => '0.013',
            from_unit => 'megabytes',
            styled_output => '104.000',
            raw_answer => '104000',
            to_unit => 'bits',
            physical_quantity => 'digital'
        })
    ),
    '1 exabyte to pib' => test_zci(
        '1 exabyte = 888.178 pebibytes',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'exabyte',
            styled_output => '888.178',
            raw_answer => '888.178',
            to_unit => 'pebibytes',
            physical_quantity => 'digital'
        })
    ),
    '16 years in months' => test_zci(
        '16 years = 192 months',
        structured_answer => make_answer({
            markup_input => '16',
            raw_input => '16',
            from_unit => 'years',
            styled_output => '192',
            raw_answer => '192',
            to_unit => 'months',
            physical_quantity => 'duration'
        })
    ),
    '1 year in months' => test_zci(
        '1 year = 12 months',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'year',
            styled_output => '12',
            raw_answer => '12',
            to_unit => 'months',
            physical_quantity => 'duration'
        })
    ),
    '360 degrees in revolutions' => test_zci(
        '360 degrees = 1 revolution',
        structured_answer => make_answer({
            markup_input => '360',
            raw_input => '360',
            from_unit => 'degrees',
            styled_output => '1',
            raw_answer => '1',
            to_unit => 'revolution',
            physical_quantity => 'angle'
        })
    ),
    '1 degree fahrenheit to celsius' => test_zci(
        '1 degree fahrenheit = -17.222 degrees celsius',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'degree fahrenheit',
            styled_output => '-17.222',
            raw_answer => '-17.222',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '12 degrees Celsius to Fahrenheit' => test_zci(
        '12 degrees celsius = 53.600 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '12',
            raw_input => '12',
            from_unit => 'degrees celsius',
            styled_output => '53.600',
            raw_answer => '53.600',
			to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '1 degrees Fahrenheit to celsius' => test_zci(
        '1 degree fahrenheit = -17.222 degrees celsius',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'degree fahrenheit',
            styled_output => '-17.222',
            raw_answer => '-17.222',
			to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '0 c in kelvin' => test_zci(
        '0 degrees celsius = 273.150 kelvin',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'degrees celsius',
            styled_output => '273.150',
            raw_answer => '273.150',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '234 f to c' => test_zci(
        '234 degrees fahrenheit = 112.222 degrees celsius',
        structured_answer => make_answer({
            markup_input => '234',
            raw_input => '234',
            from_unit => 'degrees fahrenheit',
            styled_output => '112.222',
            raw_answer => '112.222',
			to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '234 f to kelvin' => test_zci(
        '234 degrees fahrenheit = 385.372 kelvin',
        structured_answer => make_answer({
            markup_input => '234',
            raw_input => '234',
            from_unit => 'degrees fahrenheit',
            styled_output => '385.372',
            raw_answer => '385.372',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    'metres from 20 yards' => test_zci(
        '20 yards = 18.288 meters',
        structured_answer => make_answer({
            markup_input => '20',
            raw_input => '20',
            from_unit => 'yards',
            styled_output => '18.288',
            raw_answer => '18.288',
            to_unit => 'meters',
            physical_quantity => 'length'
        })
    ),
    '7 milligrams to micrograms' => test_zci(
        '7 milligrams = 7,000 micrograms',
        structured_answer => make_answer({
            markup_input => '7',
            raw_input => '7',
            from_unit => 'milligrams',
            styled_output => '7,000',
            raw_answer => '7000',
            to_unit => 'micrograms',
            physical_quantity => 'mass'
        })
    ),
    'inches in 5 meters' => test_zci(
        '5 meters = 196.850 inches',
        structured_answer => make_answer({
            markup_input => '5',
            raw_input => '5',
            from_unit => 'meters',
            styled_output => '196.850',
            raw_answer => '196.850',
            to_unit => 'inches',
            physical_quantity => 'length'
        })
    ),
    '5 inches in meters' => test_zci(
        '5 inches = 0.127 meters',
        structured_answer => make_answer({
            markup_input => '5',
            raw_input => '5',
            from_unit => 'inches',
            styled_output => '0.127',
            raw_answer => '0.127',
            to_unit => 'meters',
            physical_quantity => 'length'
        })
    ),
    'millilitres in a gallon' => test_zci(
        '1 us gallon = 3,785.412 millilitres',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'us gallon',
            styled_output => '3,785.412',
            raw_answer => '3785.412',
            to_unit => 'millilitres',
            physical_quantity => 'volume'
        })
    ),
    'gallons in a millilitres' => test_zci(
        '1 millilitre = 0.000264 us gallons',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'millilitre',
            styled_output => '0.000264',
            raw_answer => '0.000264',
            to_unit => 'us gallons',
            physical_quantity => 'volume'
        })
    ),
    'feet in an inches' => test_zci(
        '1 inch = 0.083 feet',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'inch',
            styled_output => '0.083',
            raw_answer => '0.083',
            to_unit => 'feet',
            physical_quantity => 'length'
        })
    ),
    'ml in gallons' => test_zci(
        '1 millilitre = 0.000264 us gallons',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'millilitre',
            styled_output => '0.000264',
            raw_answer => '0.000264',
            to_unit => 'us gallons',
            physical_quantity => 'volume'
        })
    ),
    'ml in gallon' => test_zci(
        '1 us gallon = 3,785.412 millilitres',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'us gallon',
            styled_output => '3,785.412',
            raw_answer => '3785.412',
            to_unit => 'millilitres',
            physical_quantity => 'volume'
        })
    ),
    '32 ml to oz' => test_zci(
        '32 millilitres = 1.082 us fluid ounces',
        structured_answer => make_answer({
            markup_input => '32',
            raw_input => '32',
            from_unit => 'millilitres',
            styled_output => '1.082',
            raw_answer => '1.082',
            to_unit => 'us fluid ounces',
            physical_quantity => 'volume'
        })
    ),
    '100 oz to ml' => test_zci(
        '100 us fluid ounces = 2,957.353 millilitres',
        structured_answer => make_answer({
            markup_input => '100',
            raw_input => '100',
            from_unit => 'us fluid ounces',
            styled_output => '2,957.353',
            raw_answer => '2957.353',
            to_unit => 'millilitres',
            physical_quantity => 'volume'
        })
    ),
    '100 ml to oz' => test_zci(
        '100 millilitres = 3.381 us fluid ounces',
        structured_answer => make_answer({
            markup_input => '100',
            raw_input => '100',
            from_unit => 'millilitres',
            styled_output => '3.381',
            raw_answer => '3.381',
            to_unit => 'us fluid ounces',
            physical_quantity => 'volume'
        })
    ),
    '75 ml to ounces' => test_zci(
        '75 millilitres = 2.536 us fluid ounces',
        structured_answer => make_answer({
            markup_input => '75',
            raw_input => '75',
            from_unit => 'millilitres',
            styled_output => '2.536',
            raw_answer => '2.536',
            to_unit => 'us fluid ounces',
            physical_quantity => 'volume'
        })
    ),
    'mm in inches' => test_zci(
        '1 millimeter = 0.039 inches',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'millimeter',
            styled_output => '0.039',
            raw_answer => '0.039',
            to_unit => 'inches',
            physical_quantity => 'length'
        })
    ),
    'mm in inch' => test_zci(
        '1 inch = 25.400 millimeters',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'inch',
            styled_output => '25.400',
            raw_answer => '25.400',
            to_unit => 'millimeters',
            physical_quantity => 'length'
        })
    ),
    'how many fl oz in a cup' => test_zci (
        '1 us cup = 8 us fluid ounces',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'us cup',
            styled_output => '8',
            raw_answer => '8',
            to_unit => 'us fluid ounces',
            physical_quantity => 'volume'
        })
    ),
    '4 cups in quarts' => test_zci(
        '4 us cups = 1 quart',
        structured_answer => make_answer({
            markup_input => '4',
            raw_input => '4',
            from_unit => 'us cups',
            styled_output => '1',
            raw_answer => '1',
            to_unit => 'quart',
            physical_quantity => 'volume'
        })
    ),
    'how many ounces in a cup' => test_zci(
        '1 us cup = 8 us fluid ounces',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'us cup',
            styled_output => '8',
            raw_answer => '8',
            to_unit => 'us fluid ounces',
            physical_quantity => 'volume'
        })
    ),
    # Unusual number formats
    '3e60 degrees in revolutions' => test_zci(
        '3 * 10^60 degrees = 8.33 * 10^57 revolutions',
        structured_answer => make_answer({
            markup_input => '3 * 10<sup>60</sup>',
            raw_input => '3*10^60',
            from_unit => 'degrees',
            styled_output => '8.33 * 10<sup>57</sup>',
            raw_answer => '8.33*10^57',
            to_unit => 'revolutions',
            physical_quantity => 'angle'
        })
    ),
    '4,1E5 newtons to pounds force' => test_zci(
        '4,1 * 10^5 newtons = 92.171,667 pounds force',
        structured_answer => make_answer({
            markup_input => '4,1 * 10<sup>5</sup>',
            raw_input => '4.1*10^5',
            from_unit => 'newtons',
            styled_output => '92.171,667',
            raw_answer => '92171.667',
            to_unit => 'pounds force',
            physical_quantity => 'force'
        })
    ),
    '4E5 newtons to pounds force' => test_zci(
        '4 * 10^5 newtons = 89,923.577 pounds force',
        structured_answer => make_answer({
            markup_input => '4 * 10<sup>5</sup>',
            raw_input => '4*10^5',
            from_unit => 'newtons',
            styled_output => '89,923.577',
            raw_answer => '89923.577',
            to_unit => 'pounds force',
            physical_quantity => 'force'
        })
    ),
    '5,0 GB to megabyte' => test_zci(
        '5,0 gigabytes = 5.000 megabytes',
        structured_answer => make_answer({
            markup_input => '5,0',
            raw_input => '5.0',
            from_unit => 'gigabytes',
            styled_output => '5.000',
            raw_answer => '5000',
            to_unit => 'megabytes',
            physical_quantity => 'digital'
        })
    ),
    '3.5e-2 miles to inches' => test_zci(
        '3.5 * 10^-2 miles = 2,217.600 inches',
        structured_answer => make_answer({
            markup_input => '3.5 * 10<sup>-2</sup>',
            raw_input => '3.5*10^-2',
            from_unit => 'miles',
            styled_output => '2,217.600',
            raw_answer => '2217.600',
            to_unit => 'inches',
            physical_quantity => 'length'
        })
    ),
    # Areas and volumes
    '100 square metres in hectares' => test_zci(
        '100 square meters = 0.010 hectares',
        structured_answer => make_answer({
            markup_input => '100',
            raw_input => '100',
            from_unit => 'square meters',
            styled_output => '0.010',
            raw_answer => '0.010',
            to_unit => 'hectares',
            physical_quantity => 'area'
        })
    ),
    '0.0001 hectares in square metres' => test_zci(
        '0.0001 hectares = 1 square meter',
        structured_answer => make_answer({
            markup_input => '0.0001',
            raw_input => '0.0001',
            from_unit => 'hectares',
            styled_output => '1',
            raw_answer => '1',
            to_unit => 'square meter',
            physical_quantity => 'area'
        })
    ),
    '5 sq mi in square meters' => test_zci(
        '5 square miles = 1.29 * 10^7 square meters',
        structured_answer => make_answer({
            markup_input => '5',
            raw_input => '5',
            from_unit => 'square miles',
            styled_output => '1.29 * 10<sup>7</sup>',
            raw_answer => '1.29*10^7',
            to_unit => 'square meters',
            physical_quantity => 'area'
        })
    ),
    '1 imperial gallon in litres' => test_zci(
        '1 imperial gallon = 4.546 litres',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'imperial gallon',
            styled_output => '4.546',
            raw_answer => '4.546',
            to_unit => 'litres',
            physical_quantity => 'volume'
        })
    ),
    '0.001 litres in millilitres' => test_zci(
        '0.001 litres = 1 millilitre',
        structured_answer => make_answer({
            markup_input => '0.001',
            raw_input => '0.001',
            from_unit => 'litres',
            styled_output => '1',
            raw_answer => '1',
            to_unit => 'millilitre',
            physical_quantity => 'volume'
        })
    ),
    '1 hectare in square metres' => test_zci(
        '1 hectare = 10,000 square meters',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'hectare',
            styled_output => '10,000',
            raw_answer => '10000',
            to_unit => 'square meters',
            physical_quantity => 'area'
        })
    ),
    '1 acre in square kilometers' => test_zci(
        '1 acre = 0.004 square kilometers',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'acre',
            styled_output => '0.004',
            raw_answer => '0.004',
            to_unit => 'square kilometers',
            physical_quantity => 'area'
        })
    ),
    '1 acres in square meters' => test_zci(
        '1 acre = 4,046.873 square meters',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'acre',
            styled_output => '4,046.873',
            raw_answer => '4046.873',
            to_unit => 'square meters',
            physical_quantity => 'area'
        })
    ),
    '1坪 in square metres' => test_zci(
        '1 坪 = 3.306 square meters',
        structured_answer => make_answer({
          markup_input => '1',
          raw_input => '1',
          from_unit => '坪',
          styled_output => '3.306',
          raw_answer => '3.306',
          to_unit => 'square meters',
          physical_quantity => 'area'
        })
    ),
    '2坪 in square metres' => test_zci(
        '2 坪 = 6.612 square meters',
        structured_answer => make_answer({
          markup_input => '2',
          raw_input => '2',
          from_unit => '坪',
          styled_output => '6.612',
          raw_answer => '6.612',
          to_unit => 'square meters',
          physical_quantity => 'area',
        })
    ),
    # Question-style
    'what is 1 inch in cm' => test_zci(
        '1 inch = 2.540 centimeters',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'inch',
            styled_output => '2.540',
            raw_answer => '2.540',
            to_unit => 'centimeters',
            physical_quantity => 'length'
        })
    ),
    'what are 10 yards in metres' => test_zci(
        '10 yards = 9.144 meters',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'yards',
            styled_output => '9.144',
            raw_answer => '9.144',
            to_unit => 'meters',
            physical_quantity => 'length'
        })
    ),
    'how long is 42 days in mins' => test_zci(
        '42 days = 60,480 minutes',
        structured_answer => make_answer({
            markup_input => '42',
            raw_input => '42',
            from_unit => 'days',
            styled_output => '60,480',
            raw_answer => '60480',
            to_unit => 'minutes',
            physical_quantity => 'duration'
        })
    ),
    'how much is 40 kelvin in celsius' => test_zci(
        '40 kelvin = -233.150 degrees celsius',
        structured_answer => make_answer({
            markup_input => '40',
            raw_input => '40',
            from_unit => 'kelvin',
            styled_output => '-233.150',
            raw_answer => '-233.150',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    'how much is 40 kelvin in celsius?' => test_zci(
        '40 kelvin = -233.150 degrees celsius',
        structured_answer => make_answer({
            markup_input => '40',
            raw_input => '40',
            from_unit => 'kelvin',
            styled_output => '-233.150',
            raw_answer => '-233.150',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    'how many metres in 10 of yard?' => test_zci(
        '10 yards = 9.144 meters',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'yards',
            styled_output => '9.144',
            raw_answer => '9.144',
            to_unit => 'meters',
            physical_quantity => 'length'
        })
    ),
    'how many metres in 10 yards?' => test_zci(
        '10 yards = 9.144 meters',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'yards',
            styled_output => '9.144',
            raw_answer => '9.144',
            to_unit => 'meters',
            physical_quantity => 'length'
        })
    ),
    'how many pounds in 1 kilogram' => test_zci(
        '1 kilogram = 2.205 pounds',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'kilogram',
            styled_output => '2.205',
            raw_answer => '2.205',
            to_unit => 'pounds',
            physical_quantity => 'mass'
        })
    ),
    'how many pounds in kilogram' => test_zci(
        '1 kilogram = 2.205 pounds',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'kilogram',
            styled_output => '2.205',
            raw_answer => '2.205',
            to_unit => 'pounds',
            physical_quantity => 'mass'
        })
    ),
    'how many pounds in kilograms?' => test_zci(
        '1 pound = 0.454 kilograms',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'pound',
            styled_output => '0.454',
            raw_answer => '0.454',
            to_unit => 'kilograms',
            physical_quantity => 'mass'
        })
    ),
    'how many cm in a metre?' => test_zci(
        '1 meter = 100 centimeters',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'meter',
            styled_output => '100',
            raw_answer => '100',
            to_unit => 'centimeters',
            physical_quantity => 'length'
        })
    ),
    'how many cm in metres?' => test_zci(
        '1 centimeter = 0.010 meters',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'centimeter',
            styled_output => '0.010',
            raw_answer => '0.010',
            to_unit => 'meters',
            physical_quantity => 'length'
        })
    ),
    'how many cm in an inch?' => test_zci(
        '1 inch = 2.540 centimeters',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'inch',
            styled_output => '2.540',
            raw_answer => '2.540',
            to_unit => 'centimeters',
            physical_quantity => 'length'
        })
    ),
    'how much is a liter in gallons?' => test_zci(
        '1 litre = 0.264 us gallons',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'litre',
            styled_output => '0.264',
            raw_answer => '0.264',
            to_unit => 'us gallons',
            physical_quantity => 'volume'
        })
    ),
    'how much is a gallon in litres?' => test_zci(
        '1 us gallon = 3.785 litres',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'us gallon',
            styled_output => '3.785',
            raw_answer => '3.785',
            to_unit => 'litres',
            physical_quantity => 'volume'
        })
    ),
    'how many gallons in a litre' => test_zci(
        '1 litre = 0.264 us gallons',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'litre',
            styled_output => '0.264',
            raw_answer => '0.264',
            to_unit => 'us gallons',
            physical_quantity => 'volume'
        })
    ),
    'number of cm in 100 m' => test_zci(
        '100 meters = 10,000 centimeters',
        structured_answer => make_answer({
            markup_input => '100',
            raw_input => '100',
            from_unit => 'meters',
            styled_output => '10,000',
            raw_answer => '10000',
            to_unit => 'centimeters',
            physical_quantity => 'length'
        })
    ),
    '1 acres in square kilometers' => test_zci(
        '1 acre = 0.004 square kilometers',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'acre',
            styled_output => '0.004',
            raw_answer => '0.004',
            to_unit => 'square kilometers',
            physical_quantity => 'area'
        })
    ),
    '1 acres in square meters' => test_zci(
        '1 acre = 4,046.873 square meters',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'acre',
            styled_output => '4,046.873',
            raw_answer => '4046.873',
            to_unit => 'square meters',
            physical_quantity => 'area'
        })
    ),
    '-40 fahrenheit in celsius' => test_zci(
        '-40 degrees fahrenheit = -40 degrees celsius',
        structured_answer => make_answer({
            markup_input => '-40',
            raw_input => '-40',
            from_unit => 'degrees fahrenheit',
            styled_output => '-40',
            raw_answer => '-40',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '-40 celsius in fahrenheit' => test_zci(
        '-40 degrees celsius = -40 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '-40',
            raw_input => '-40',
            from_unit => 'degrees celsius',
            styled_output => '-40',
            raw_answer => '-40',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    
    ## Full suite of tests around temperatures
    # for computational accuracy rather than
    # parsing accuracy
    '10 fahrenheit in fahrenheit' => test_zci(
        '10 degrees fahrenheit = 10 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'degrees fahrenheit',
            styled_output => '10',
            raw_answer => '10',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '10 celsius in fahrenheit' => test_zci(
        '10 degrees celsius = 50 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'degrees celsius',
            styled_output => '50',
            raw_answer => '50',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '10 kelvin in fahrenheit' => test_zci(
        '10 kelvin = -441.670 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'kelvin',
            styled_output => '-441.670',
            raw_answer => '-441.670',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '10 rankine in fahrenheit' => test_zci(
        '10 degrees rankine = -449.670 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'degrees rankine',
            styled_output => '-449.670',
            raw_answer => '-449.670',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '1234 fahrenheit in fahrenheit' => test_zci(
        '1,234 degrees fahrenheit = 1,234 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'degrees fahrenheit',
            styled_output => '1,234',
            raw_answer => '1234',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '1234 celsius in fahrenheit' => test_zci(
        '1,234 degrees celsius = 2,253.200 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'degrees celsius',
            styled_output => '2,253.200',
            raw_answer => '2253.200',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '1234 kelvin in fahrenheit' => test_zci(
        '1,234 kelvin = 1,761.530 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'kelvin',
            styled_output => '1,761.530',
            raw_answer => '1761.530',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '1234 rankine in fahrenheit' => test_zci(
        '1,234 degrees rankine = 774.330 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'degrees rankine',
            styled_output => '774.330',
            raw_answer => '774.330',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '-87 fahrenheit in fahrenheit' => test_zci(
        '-87 degrees fahrenheit = -87 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '-87',
            raw_input => '-87',
            from_unit => 'degrees fahrenheit',
            styled_output => '-87',
            raw_answer => '-87',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '-87 celsius in fahrenheit' => test_zci(
        '-87 degrees celsius = -124.600 degrees fahrenheit',        
        structured_answer => make_answer({
            markup_input => '-87',
            raw_input => '-87',
            from_unit => 'degrees celsius',
            styled_output => '-124.600',
            raw_answer => '-124.600',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '-87 kelvin in fahrenheit' => undef,
    '-87 rankine in fahrenheit' => undef,
    '-7 fahrenheit in fahrenheit' => test_zci(
        '-7 degrees fahrenheit = -7 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '-7',
            raw_input => '-7',
            from_unit => 'degrees fahrenheit',
            styled_output => '-7',
            raw_answer => '-7',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '-7 celsius in fahrenheit' => test_zci(
        '-7 degrees celsius = 19.400 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '-7',
            raw_input => '-7',
            from_unit => 'degrees celsius',
            styled_output => '19.400',
            raw_answer => '19.400',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '-7 kelvin in fahrenheit' => undef,
    '-7 rankine in fahrenheit' => undef,
    
    '0 fahrenheit in fahrenheit' => test_zci(
        '0 degrees fahrenheit = 0 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'degrees fahrenheit',
            styled_output => '0',
            raw_answer => '0',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),,
    '0 celsius in fahrenheit' => test_zci(
        '0 degrees celsius = 32 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'degrees celsius',
            styled_output => '32',
            raw_answer => '32',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '0 kelvin in fahrenheit' => test_zci(
        '0 kelvin = -459.670 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'kelvin',
            styled_output => '-459.670',
            raw_answer => '-459.670',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '0 rankine in fahrenheit' => test_zci(
        '0 degrees rankine = -459.670 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'degrees rankine',
            styled_output => '-459.670',
            raw_answer => '-459.670',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '10 fahrenheit in celsius' => test_zci(
        '10 degrees fahrenheit = -12.222 degrees celsius',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'degrees fahrenheit',
            styled_output => '-12.222',
            raw_answer => '-12.222',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '10 celsius in celsius' => test_zci(
        '10 degrees celsius = 10 degrees celsius',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'degrees celsius',
            styled_output => '10',
            raw_answer => '10',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '10 kelvin in celsius' => test_zci(
        '10 kelvin = -263.150 degrees celsius',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'kelvin',
            styled_output => '-263.150',
            raw_answer => '-263.150',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '10 rankine in celsius' => test_zci(
        '10 degrees rankine = -267.594 degrees celsius',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'degrees rankine',
            styled_output => '-267.594',
            raw_answer => '-267.594',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    
    '1234 fahrenheit in celsius' => test_zci(
        '1,234 degrees fahrenheit = 667.778 degrees celsius',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'degrees fahrenheit',
            styled_output => '667.778',
            raw_answer => '667.778',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '1234 celsius in celsius' => test_zci(
        '1,234 degrees celsius = 1,234 degrees celsius',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'degrees celsius',
            styled_output => '1,234',
            raw_answer => '1234',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '1234 kelvin in celsius' => test_zci(
        '1,234 kelvin = 960.850 degrees celsius',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'kelvin',
            styled_output => '960.850',
            raw_answer => '960.850',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '1234 rankine in celsius' => test_zci(
        '1,234 degrees rankine = 412.406 degrees celsius',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'degrees rankine',
            styled_output => '412.406',
            raw_answer => '412.406',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '-87 fahrenheit in celsius' => test_zci(
        '-87 degrees fahrenheit = -66.111 degrees celsius',
        structured_answer => make_answer({
            markup_input => '-87',
            raw_input => '-87',
            from_unit => 'degrees fahrenheit',
            styled_output => '-66.111',
            raw_answer => '-66.111',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '-87 celsius in celsius' => test_zci(
        '-87 degrees celsius = -87 degrees celsius',
        structured_answer => make_answer({
            markup_input => '-87',
            raw_input => '-87',
            from_unit => 'degrees celsius',
            styled_output => '-87',
            raw_answer => '-87',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '-87 kelvin in celsius' => undef,
    '-87 rankine in celsius' => undef,
    '-7 fahrenheit in celsius' => test_zci(
        '-7 degrees fahrenheit = -21.667 degrees celsius',
        structured_answer => make_answer({
            markup_input => '-7',
            raw_input => '-7',
            from_unit => 'degrees fahrenheit',
            styled_output => '-21.667',
            raw_answer => '-21.667',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '-7 celsius in celsius' => test_zci(
        '-7 degrees celsius = -7 degrees celsius',
        structured_answer => make_answer({
            markup_input => '-7',
            raw_input => '-7',
            from_unit => 'degrees celsius',
            styled_output => '-7',
            raw_answer => '-7',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '-7 kelvin in celsius' => undef,
    '-7 rankine in celsius' => undef,
    '0 fahrenheit in celsius' => test_zci(
        '0 degrees fahrenheit = -17.778 degrees celsius',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'degrees fahrenheit',
            styled_output => '-17.778',
            raw_answer => '-17.778',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '0 celsius in celsius' => test_zci(
        '0 degrees celsius = 0 degrees celsius',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'degrees celsius',
            styled_output => '0',
            raw_answer => '0',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),,
    '0 kelvin in celsius' => test_zci(
        '0 kelvin = -273.150 degrees celsius',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'kelvin',
            styled_output => '-273.150',
            raw_answer => '-273.150',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '0 rankine in celsius' => test_zci(
        '0 degrees rankine = -273.150 degrees celsius',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'degrees rankine',
            styled_output => '-273.150',
            raw_answer => '-273.150',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '10 fahrenheit in kelvin' => test_zci(
        '10 degrees fahrenheit = 260.928 kelvin',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'degrees fahrenheit',
            styled_output => '260.928',
            raw_answer => '260.928',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '10 celsius in kelvin' => test_zci(
        '10 degrees celsius = 283.150 kelvin',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'degrees celsius',
            styled_output => '283.150',
            raw_answer => '283.150',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '10 kelvin in kelvin' => test_zci(
        '10 kelvin = 10 kelvin',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'kelvin',
            styled_output => '10',
            raw_answer => '10',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '10 rankine in kelvin' => test_zci(
        '10 degrees rankine = 5.556 kelvin',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'degrees rankine',
            styled_output => '5.556',
            raw_answer => '5.556',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '1234 fahrenheit in kelvin' => test_zci(
        '1,234 degrees fahrenheit = 940.928 kelvin',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'degrees fahrenheit',
            styled_output => '940.928',
            raw_answer => '940.928',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '1234 celsius in kelvin' => test_zci(
        '1,234 degrees celsius = 1,507.150 kelvin',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'degrees celsius',
            styled_output => '1,507.150',
            raw_answer => '1507.150',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '1234 kelvin in kelvin' => test_zci(
        '1,234 kelvin = 1,234 kelvin',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'kelvin',
            styled_output => '1,234',
            raw_answer => '1234',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '1234 rankine in kelvin' => test_zci(
        '1,234 degrees rankine = 685.556 kelvin',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'degrees rankine',
            styled_output => '685.556',
            raw_answer => '685.556',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '-87 fahrenheit in kelvin' => test_zci(
        '-87 degrees fahrenheit = 207.039 kelvin',
        structured_answer => make_answer({
            markup_input => '-87',
            raw_input => '-87',
            from_unit => 'degrees fahrenheit',
            styled_output => '207.039',
            raw_answer => '207.039',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '-87 celsius in kelvin' => test_zci(
        '-87 degrees celsius = 186.150 kelvin',
        structured_answer => make_answer({
            markup_input => '-87',
            raw_input => '-87',
            from_unit => 'degrees celsius',
            styled_output => '186.150',
            raw_answer => '186.150',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '-87 kelvin in kelvin' => undef,
    '-87 rankine in kelvin' => undef,
    
    '-7 fahrenheit in kelvin' => test_zci(
        '-7 degrees fahrenheit = 251.483 kelvin',
        structured_answer => make_answer({
            markup_input => '-7',
            raw_input => '-7',
            from_unit => 'degrees fahrenheit',
            styled_output => '251.483',
            raw_answer => '251.483',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '-7 celsius in kelvin' => test_zci(
        '-7 degrees celsius = 266.150 kelvin',
        structured_answer => make_answer({
            markup_input => '-7',
            raw_input => '-7',
            from_unit => 'degrees celsius',
            styled_output => '266.150',
            raw_answer => '266.150',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '-7 kelvin in kelvin' => undef,
    '-7 rankine in kelvin' => undef,
    '0 fahrenheit in kelvin' => test_zci(
        '0 degrees fahrenheit = 255.372 kelvin',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'degrees fahrenheit',
            styled_output => '255.372',
            raw_answer => '255.372',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '0 celsius in kelvin' => test_zci(
        '0 degrees celsius = 273.150 kelvin',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'degrees celsius',
            styled_output => '273.150',
            raw_answer => '273.150',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '0 kelvin in kelvin' => test_zci(
        '0 kelvin = 0 kelvin',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'kelvin',
            styled_output => '0',
            raw_answer => '0',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),,
    '0 rankine in kelvin' => test_zci(
        '0 degrees rankine = 0 kelvin',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'degrees rankine',
            styled_output => '0',
            raw_answer => '0',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    
    '10 fahrenheit in rankine' => test_zci(
        '10 degrees fahrenheit = 469.670 degrees rankine',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'degrees fahrenheit',
            styled_output => '469.670',
            raw_answer => '469.670',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '10 celsius in rankine' => test_zci(
        '10 degrees celsius = 509.670 degrees rankine',        
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'degrees celsius',
            styled_output => '509.670',
            raw_answer => '509.670',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '10 kelvin in rankine' => test_zci(
        '10 kelvin = 18 degrees rankine',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'kelvin',
            styled_output => '18',
            raw_answer => '18',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '10 rankine in rankine' => test_zci(
        '10 degrees rankine = 10 degrees rankine',
        structured_answer => make_answer({
            markup_input => '10',
            raw_input => '10',
            from_unit => 'degrees rankine',
            styled_output => '10',
            raw_answer => '10',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '1234 fahrenheit in rankine' => test_zci(
        '1,234 degrees fahrenheit = 1,693.670 degrees rankine',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'degrees fahrenheit',
            styled_output => '1,693.670',
            raw_answer => '1693.670',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '1234 celsius in rankine' => test_zci(
        '1,234 degrees celsius = 2,712.870 degrees rankine',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'degrees celsius',
            styled_output => '2,712.870',
            raw_answer => '2712.870',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '1234 kelvin in rankine' => test_zci(
        '1,234 kelvin = 2,221.200 degrees rankine',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'kelvin',
            styled_output => '2,221.200',
            raw_answer => '2221.200',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '1234 rankine in rankine' => test_zci(
        '1,234 degrees rankine = 1,234 degrees rankine',
        structured_answer => make_answer({
            markup_input => '1,234',
            raw_input => '1234',
            from_unit => 'degrees rankine',
            styled_output => '1,234',
            raw_answer => '1234',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '-87 fahrenheit in rankine' => test_zci(
        '-87 degrees fahrenheit = 372.670 degrees rankine',
        structured_answer => make_answer({
            markup_input => '-87',
            raw_input => '-87',
            from_unit => 'degrees fahrenheit',
            styled_output => '372.670',
            raw_answer => '372.670',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '-87 celsius in rankine' => test_zci(
        '-87 degrees celsius = 335.070 degrees rankine',
        structured_answer => make_answer({
            markup_input => '-87',
            raw_input => '-87',
            from_unit => 'degrees celsius',
            styled_output => '335.070',
            raw_answer => '335.070',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '-87 kelvin in rankine' => undef,
    '-87 rankine in rankine' => undef,
    '-7 fahrenheit in rankine' => test_zci(
        '-7 degrees fahrenheit = 452.670 degrees rankine',
        structured_answer => make_answer({
            markup_input => '-7',
            raw_input => '-7',
            from_unit => 'degrees fahrenheit',
            styled_output => '452.670',
            raw_answer => '452.670',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '-7 celsius in rankine' => test_zci(
        '-7 degrees celsius = 479.070 degrees rankine',
        structured_answer => make_answer({
            markup_input => '-7',
            raw_input => '-7',
            from_unit => 'degrees celsius',
            styled_output => '479.070',
            raw_answer => '479.070',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '-7 kelvin in rankine' => undef,
    '-7 rankine in rankine' => undef,
    '0 fahrenheit in rankine' => test_zci(
        '0 degrees fahrenheit = 459.670 degrees rankine',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'degrees fahrenheit',
            styled_output => '459.670',
            raw_answer => '459.670',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '0 celsius in rankine' => test_zci(
        '0 degrees celsius = 491.670 degrees rankine',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'degrees celsius',
            styled_output => '491.670',
            raw_answer => '491.670',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '0 kelvin in rankine' => test_zci(
        '0 kelvin = 0 degrees rankine',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'kelvin',
            styled_output => '0',
            raw_answer => '0',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '0 rankine in rankine' => test_zci(
        '0 degrees rankine = 0 degrees rankine',
        structured_answer => make_answer({
            markup_input => '0',
            raw_input => '0',
            from_unit => 'degrees rankine',
            styled_output => '0',
            raw_answer => '0',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),,
        
    '84856 fahrenheit in fahrenheit' => test_zci(
        '84,856 degrees fahrenheit = 84,856 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'degrees fahrenheit',
            styled_output => '84,856',
            raw_answer => '84856',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '84856 celsius in fahrenheit' => test_zci(
        '84,856 degrees celsius = 152,772.800 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'degrees celsius',
            styled_output => '152,772.800',
            raw_answer => '152772.800',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '84856 kelvin in fahrenheit' => test_zci(
        '84,856 kelvin = 152,281.130 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'kelvin',
            styled_output => '152,281.130',
            raw_answer => '152281.130',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '84856 rankine in fahrenheit' => test_zci(
        '84,856 degrees rankine = 84,396.330 degrees fahrenheit',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'degrees rankine',
            styled_output => '84,396.330',
            raw_answer => '84396.330',
            to_unit => 'degrees fahrenheit',
            physical_quantity => 'temperature'
        })
    ),
    '84856 fahrenheit in celsius' => test_zci(
        '84,856 degrees fahrenheit = 47,124.444 degrees celsius',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'degrees fahrenheit',
            styled_output => '47,124.444',
            raw_answer => '47124.444',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '84856 celsius in celsius' => test_zci(
        '84,856 degrees celsius = 84,856 degrees celsius',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'degrees celsius',
            styled_output => '84,856',
            raw_answer => '84856',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '84856 kelvin in celsius' => test_zci(
        '84,856 kelvin = 84,582.850 degrees celsius',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'kelvin',
            styled_output => '84,582.850',
            raw_answer => '84582.850',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '84856 rankine in celsius' => test_zci(
        '84,856 degrees rankine = 46,869.072 degrees celsius',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'degrees rankine',
            styled_output => '46,869.072',
            raw_answer => '46869.072',
            to_unit => 'degrees celsius',
            physical_quantity => 'temperature'
        })
    ),
    '84856 fahrenheit in kelvin' => test_zci(
        '84,856 degrees fahrenheit = 47,397.594 kelvin',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'degrees fahrenheit',
            styled_output => '47,397.594',
            raw_answer => '47397.594',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '84856 celsius in kelvin' => test_zci(
        '84,856 degrees celsius = 85,129.150 kelvin',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'degrees celsius',
            styled_output => '85,129.150',
            raw_answer => '85129.150',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '84856 kelvin in kelvin' => test_zci(
        '84,856 kelvin = 84,856 kelvin',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'kelvin',
            styled_output => '84,856',
            raw_answer => '84856',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '84856 rankine in kelvin' => test_zci(
        '84,856 degrees rankine = 47,142.222 kelvin',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'degrees rankine',
            styled_output => '47,142.222',
            raw_answer => '47142.222',
            to_unit => 'kelvin',
            physical_quantity => 'temperature'
        })
    ),
    '84856 fahrenheit in rankine' => test_zci(
        '84,856 degrees fahrenheit = 85,315.670 degrees rankine',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'degrees fahrenheit',
            styled_output => '85,315.670',
            raw_answer => '85315.670',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '84856 celsius in rankine' => test_zci(
        '84,856 degrees celsius = 153,232.470 degrees rankine',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'degrees celsius',
            styled_output => '153,232.470',
            raw_answer => '153232.470',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '84856 kelvin in rankine' => test_zci(
        '84,856 kelvin = 152,740.800 degrees rankine',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'kelvin',
            styled_output => '152,740.800',
            raw_answer => '152740.800',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    '84856 rankine in rankine' => test_zci(
        '84,856 degrees rankine = 84,856 degrees rankine',
        structured_answer => make_answer({
            markup_input => '84,856',
            raw_input => '84856',
            from_unit => 'degrees rankine',
            styled_output => '84,856',
            raw_answer => '84856',
            to_unit => 'degrees rankine',
            physical_quantity => 'temperature'
        })
    ),
    
    #Question format:
    'How to convert meters to inches' => test_zci(
        '1 meter = 39.370 inches',
        structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'meter',
            styled_output => '39.370',
            raw_answer => '39.370',
            to_unit => 'inches',
            physical_quantity => 'length'
        })
    ),
    '250 feet to inches' => test_zci(
        '250 feet = 3,000 inches',
        structured_answer => make_answer({
            markup_input => '250',
            raw_input => '250',
            from_unit => 'feet',
            styled_output => '3,000',
            raw_answer => '3000',
            to_unit => 'inches',
            physical_quantity => 'length'
        })
    ),
	# Representation (scientific notation)
	'30000 km to m' => test_zci(
        '30,000 kilometers = 3 * 10^7 meters',
        structured_answer => make_answer({
            markup_input => '30,000',
            raw_input => '30000',
            from_unit => 'kilometers',
            styled_output => '3 * 10<sup>7</sup>',
            raw_answer => '3*10^7',
            to_unit => 'meters',
            physical_quantity => 'length'
        })
	),
    
    '3000000000000000 km to m' => test_zci(
        '3 * 10^15 kilometers = 3 * 10^18 meters',
		structured_answer => make_answer({
            markup_input => '3 * 10<sup>15</sup>',
            raw_input => '3*10^15',
            from_unit => 'kilometers',
            styled_output => '3 * 10<sup>18</sup>',
            raw_answer => '3*10^18',
            to_unit => 'meters',
            physical_quantity => 'length'
        })
    ),
    '3000 km to m' => test_zci(
        '3,000 kilometers = 3 * 10^6 meters',
		structured_answer => make_answer({
            markup_input => '3,000',
            raw_input => '3000',
            from_unit => 'kilometers',
            styled_output => '3 * 10<sup>6</sup>',
            raw_answer => '3*10^6',
            to_unit => 'meters',
            physical_quantity => 'length'
        })
    ),
    '300000000000 km to m' => test_zci(
        '3 * 10^11 kilometers = 3 * 10^14 meters',
		structured_answer => make_answer({
            markup_input => '3 * 10<sup>11</sup>',
            raw_input => '3*10^11',
            from_unit => 'kilometers',
            styled_output => '3 * 10<sup>14</sup>',
            raw_answer => '3*10^14',
            to_unit => 'meters',
            physical_quantity => 'length'
        })
    ),
    '4e-15 km to mm' => test_zci(
        '4 * 10^-15 kilometers = 4 * 10^-9 millimeters',
		structured_answer => make_answer({
            markup_input => '4 * 10<sup>-15</sup>',
            raw_input => '4*10^-15',
            from_unit => 'kilometers',
            styled_output => '4 * 10<sup>-9</sup>',
            raw_answer => '4*10^-9',
            to_unit => 'millimeters',
            physical_quantity => 'length'
        })
    ),
    'how many megabytes in a gigabyte?' => test_zci(
        '1 gigabyte = 1,000 megabytes',
		structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'gigabyte',
            styled_output => '1,000',
            raw_answer => '1000',
            to_unit => 'megabytes',
            physical_quantity => 'digital'
        })
    ),
    '1 gigabyte in megabytes' => test_zci(
        '1 gigabyte = 1,000 megabytes',
		structured_answer => make_answer({
            markup_input => '1',
            raw_input => '1',
            from_unit => 'gigabyte',
            styled_output => '1,000',
            raw_answer => '1000',
            to_unit => 'megabytes',
            physical_quantity => 'digital'
        })
    ),

    # Intentionally untriggered
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
    'Seconds'                         => undef,
    'feet'                            => undef,
    'minutes'                         => undef,
    '99999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 miles in mm' => undef,
    '1E300 miles in metres'           => undef
);
done_testing;
