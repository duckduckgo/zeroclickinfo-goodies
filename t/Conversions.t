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
            styled_output     => $input->{'styled_output'}),
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
        structured_answer => {
            input => '5 ounces',
            output => '141.747 grams',
			physical_quantity => 'mass'
        }
    ),
    '5 ounces to g' => test_zci(
        '5 ounces = 141.747 grams',
        structured_answer => {
            input => '5 ounces',
            output => '141.747 grams',
			physical_quantity => 'mass'
        }
    ),
    '0.5 nautical miles in km' => test_zci(
        '0.5 nautical miles = 0.926 kilometers',
        structured_answer => {
            input => '0.5 nautical miles',
            output => '0.926 kilometers',
			physical_quantity => 'length'
        }
    ),
    # Explicit conversion requests
    'convert 1 ton to long ton' => test_zci(
        '1 ton = 0.893 long tons',
        structured_answer => {
            input => '1 ton',
            output => '0.893 long tons',
			physical_quantity => 'mass'
        }
    ),
    'convert 158 ounce to lbm' => test_zci(
        '158 ounces = 9.875 pounds',
        structured_answer => {
            input => '158 ounces',
            output => '9.875 pounds',
			physical_quantity => 'mass'
        }
    ),
    'convert 0.111 stone to pound' => test_zci(
        '0.111 stone = 1.554 pounds',
        structured_answer => {
            input => '0.111 stone',
            output => '1.554 pounds',
			physical_quantity => 'mass'
        }
    ),
    'convert 5 feet to in' => test_zci(
        '5 feet = 60 inches',
        structured_answer => {
            input => '5 feet',
            output => '60 inches',
			physical_quantity => 'length'
        }
    ),
    'convert 5 kelvin to fahrenheit' => test_zci(
        '5 kelvin = -450.670 degrees fahrenheit',
        structured_answer => {
            input => '5 kelvin',
            output => "-450.670 degrees fahrenheit",
			physical_quantity => 'temperature'
        }
    ),
    'light year to mm' => test_zci(
        '1 light year = 9.46 * 10^18 millimeters',
        structured_answer => {
            input => '1 light year',
            output => '9.46 * 10<sup>18</sup> millimeters',
			physical_quantity => 'length'
        }
    ),
    'BTU to KwH' => test_zci(
        '1 british thermal unit = 0.000293 kilowatt-hours',
        structured_answer => {
            input => '1 british thermal unit',
            output => '0.000293 kilowatt-hours',
			physical_quantity => 'energy'
			
        }
    ),
    'convert 25 inches into feet' => test_zci(
        '25 inches = 2.083 feet',
        structured_answer => {
            input => '25 inches',
            output => '2.083 feet',
			physical_quantity => 'length'
        }
    ),
    'convert 5 f to celsius' => test_zci(
        '5 degrees fahrenheit = -15 degrees celsius',
        structured_answer => {
            input => '5 degrees fahrenheit',
            output => "-15 degrees celsius",
			physical_quantity => 'temperature'
        }
    ),
    'convert km to cm' => test_zci(
        '1 kilometer = 100,000 centimeters',
        structured_answer => {
            input => '1 kilometer',
            output => '100,000 centimeters',
			physical_quantity => 'length'
        }
    ),
    'convert 10ms to seconds' => test_zci(
        '10 milliseconds = 0.010 seconds',
        structured_answer => {
            input => '10 milliseconds',
            output => '0.010 seconds',
			physical_quantity => 'time'
        }
    ),
    'convert 1 yb to yib' => test_zci(
        '1 yottabyte = 0.827 yobibytes',
        structured_answer => {
            input => '1 yottabyte',
            output => '0.827 yobibytes',
			physical_quantity => 'information'
        }
    ),
    'convert 1stone to lbs' => test_zci(
        '1 stone = 14 pounds',
        structured_answer => {
            input => '1 stone',
            output => '14 pounds',
			physical_quantity => 'mass'
        }
    ),
    'convert 5 bytes to bit' => test_zci(
        '5 bytes = 40 bits',
        structured_answer => {
            input => '5 bytes',
            output => '40 bits',
			physical_quantity => 'information'
        }
    ),
    # Implicit conversion requests
    '3 kilogramme to pound' => test_zci(
        '3 kilograms = 6.614 pounds',
        structured_answer => {
            input => '3 kilograms',
            output => '6.614 pounds',
			physical_quantity => 'mass'
        }
    ),
    '1.3 tonnes to ton' => test_zci(
        '1.3 metric tons = 1.433 tons',
        structured_answer => {
            input => '1.3 metric tons',
            output => '1.433 tons',
			physical_quantity => 'mass'
        }
    ),
    '2 tons to kg' => test_zci(
        '2 tons = 1,814.372 kilograms',
        structured_answer => {
            input => '2 tons',
            output => '1,814.372 kilograms',
			physical_quantity => 'mass'
        }
    ),
    '1 ton to kilos' => test_zci(
        '1 ton = 907.186 kilograms',
        structured_answer => {
            input => '1 ton',
            output => '907.186 kilograms',
			physical_quantity => 'mass'
        }
    ),
    '3.9 oz in g' => test_zci(
        '3.9 ounces = 110.563 grams',
        structured_answer => {
            input => '3.9 ounces',
            output => '110.563 grams',
			physical_quantity => 'mass'
        }
    ),
    '2 miles to km' => test_zci(
        '2 miles = 3.219 kilometers',
        structured_answer => {
            input => '2 miles',
            output => '3.219 kilometers',
			physical_quantity => 'length'
        }
    ),
    '3 mi to km' => test_zci(
        '3 miles = 4.828 kilometers',
        structured_answer => {
            input => '3 miles',
            output => '4.828 kilometers',
			physical_quantity => 'length'
        }
    ),
    '0.5 nautical mile to klick' => test_zci(
        '0.5 nautical miles = 0.926 kilometers',
        structured_answer => {
            input => '0.5 nautical miles',
            output => '0.926 kilometers',
			physical_quantity => 'length'
        }
    ),
    '500 miles in metres' => test_zci(
        '500 miles = 804,672 meters',
        structured_answer => {
            input => '500 miles',
            output => '804,672 meters',
			physical_quantity => 'length'
        }
    ),
    '25 cm in inches' => test_zci(
        '25 centimeters = 9.843 inches',
        structured_answer => {
            input => '25 centimeters',
            output => '9.843 inches',
			physical_quantity => 'length'
        }
    ),
    '1760 yards to miles' => test_zci(
        '1,760 yards = 1 mile',
        structured_answer => {
            input => '1,760 yards',
            output => '1 mile',
			physical_quantity => 'length'
        }
    ),
    '3520yards to miles' => test_zci(
        '3,520 yards = 2 miles',
        structured_answer => {
            input => '3,520 yards',
            output => '2 miles',
			physical_quantity => 'length'
        }
    ),
    '30cm in in' => test_zci(
        '30 centimeters = 11.811 inches',
        structured_answer => {
            input => '30 centimeters',
            output => '11.811 inches',
			physical_quantity => 'length'
        }
    ),
    '36 months to years' => test_zci(
        '36 months = 3 years',
        structured_answer => {
            input => '36 months',
            output => '3 years',
			physical_quantity => 'time'
        }
    ),
    '43200 seconds in hours' => test_zci(
        '43,200 seconds = 12 hours',
        structured_answer => {
            input => '43,200 seconds',
            output => '12 hours',
			physical_quantity => 'time'
        }
    ),
    '4 hours to minutes' => test_zci(
        '4 hours = 240 minutes',
        structured_answer => {
            input => '4 hours',
            output => '240 minutes',
			physical_quantity => 'time'
        }
    ),
    '1 bar to pascal' => test_zci(
        '1 bar = 100,000 pascals',
        structured_answer => {
            input => '1 bar',
            output => '100,000 pascals',
			physical_quantity => 'pressure'
        }
    ),
    '1 kilopascal to psi' => test_zci(
        '1 kilopascal = 0.145 pounds per square inch',
        structured_answer => {
            input => '1 kilopascal',
            output => '0.145 pounds per square inch',
			physical_quantity => 'pressure'
        }
    ),
    '1 atm to kpa' => test_zci(
        '1 atmosphere = 101.325 kilopascals',
        structured_answer => {
            input => '1 atmosphere',
            output => '101.325 kilopascals',
			physical_quantity => 'pressure'
        }
    ),
    '5yrds to km' => test_zci(
        '5 yards = 0.005 kilometers',
        structured_answer => {
            input => '5 yards',
            output => '0.005 kilometers',
			physical_quantity => 'length'
        }
    ),
    '12" to cm' => test_zci(
        '12 inches = 30.480 centimeters',
        structured_answer => {
            input => '12 inches',
            output => '30.480 centimeters',
			physical_quantity => 'length'
        }
    ),
    '42 kilowatt hours in joules' => test_zci(
        '42 kilowatt-hours = 1.51 * 10^8 joules',
        structured_answer => {
            input => '42 kilowatt-hours',
            output => '1.51 * 10<sup>8</sup> joules',
			physical_quantity => 'energy'
        }
    ),
    '2500kcal in tons of tnt' => test_zci(
        '2,500 large calories = 0.003 tons of TNT',
        structured_answer => {
            input => '2,500 large calories',
            output => '0.003 tons of TNT',
			physical_quantity => 'energy'
        }
    ),
    '90 ps in watts' => test_zci(
        '90 metric horsepower = 66,194.888 watts',
        structured_answer => {
            input => '90 metric horsepower',
            output => '66,194.888 watts',
			physical_quantity => 'power'
        }
    ),
    '1 gigawatt in horsepower' => test_zci(
        '1 gigawatt = 1.34 * 10^6 horsepower',
        structured_answer => {
            input => '1 gigawatt',
            output => '1.34 * 10<sup>6</sup> horsepower',
			physical_quantity => 'power'
        }
    ),
    '180 degrees in radians' => test_zci(
        '180 degrees = 3.142 radians',
        structured_answer => {
            input => '180 degrees',
            output => '3.142 radians',
			physical_quantity => 'angle'
        }
    ),
    '270 degrees in quadrants' => test_zci(
        '270 degrees = 3 quadrants',
        structured_answer => {
            input => '270 degrees',
            output => '3 quadrants',
			physical_quantity => 'angle'
        }
    ),
    '180 degrees in grads' => test_zci(
        '180 degrees = 200 gradians',
        structured_answer => {
            input => '180 degrees',
            output => '200 gradians',
			physical_quantity => 'angle'
        }
    ),
    '45 newtons to pounds force' => test_zci(
        '45 newtons = 10.116 pounds force',
        structured_answer => {
            input => '45 newtons',
            output => '10.116 pounds force',
			physical_quantity => 'force'
        }
    ),
    '8 poundal to newtons' => test_zci(
        '8 poundals = 1.106 newtons',
        structured_answer => {
            input => '8 poundals',
            output => '1.106 newtons',
			physical_quantity => 'force'
        }
    ),
    '10 mg to tons' => test_zci(
        '10 milligrams = 1.1 * 10^-8 tons',
        structured_answer => {
            input => '10 milligrams',
            output => '1.1 * 10<sup>-8</sup> tons',
			physical_quantity => 'mass'
        }
    ),
    '10000 minutes in microseconds' => test_zci(
        '10,000 minutes = 6 * 10^11 microseconds',
        structured_answer => {
            input => '10,000 minutes',
            output => '6 * 10<sup>11</sup> microseconds',
			physical_quantity => 'time'
        }
    ),
    '5 GB to megabyte' => test_zci(
        '5 gigabytes = 5,000 megabytes',
        structured_answer => {
            input => '5 gigabytes',
            output => '5,000 megabytes',
			physical_quantity => 'information'
        }
    ),
    '0.013 mb in bits' => test_zci(
        '0.013 megabytes = 104,000 bits',
        structured_answer => {
            input => '0.013 megabytes',
            output => '104,000 bits',
			physical_quantity => 'information'
        }
    ),
    '0,013 mb in bits' => test_zci(
        '0,013 megabytes = 104.000 bits',
        structured_answer => {
            input => '0,013 megabytes',
            output => '104.000 bits',
			physical_quantity => 'information'
        }
    ),
    '1 exabyte to pib' => test_zci(
        '1 exabyte = 888.178 pebibytes',
        structured_answer => {
            input => '1 exabyte',
            output => '888.178 pebibytes',
			physical_quantity => 'information'
        }
    ),
    '16 years in months' => test_zci(
        '16 years = 192 months',
        structured_answer => {
            input => '16 years',
            output => '192 months',
			physical_quantity => 'time'
        }
    ),
    '1 year in months' => test_zci(
        '1 year = 12 months',
        structured_answer => {
            input => '1 year',
            output => '12 months',
			physical_quantity => 'time'
        }
    ),
    '360 degrees in revolutions' => test_zci(
        '360 degrees = 1 revolution',
        structured_answer => {
            input => '360 degrees',
            output => '1 revolution',
			physical_quantity => 'angle'
        }
    ),
    '1 degree fahrenheit to celsius' => test_zci(
        '1 degree fahrenheit = -17.222 degrees celsius',
        structured_answer => {
            input => '1 degree fahrenheit',
            output => '-17.222 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '12 degrees Celsius to Fahrenheit' => test_zci(
        '12 degrees celsius = 53.600 degrees fahrenheit',
        structured_answer => {
            input => '12 degrees celsius',
            output => "53.600 degrees fahrenheit",
			physical_quantity => 'temperature'
        }
    ),
    '1 degrees Fahrenheit to celsius' => test_zci(
        '1 degree fahrenheit = -17.222 degrees celsius',
        structured_answer => {
            input => '1 degree fahrenheit',
            output => "-17.222 degrees celsius",
			physical_quantity => 'temperature'
        }
    ),
    '0 c in kelvin' => test_zci(
        '0 degrees celsius = 273.150 kelvin',
        structured_answer => {
            input => '0 degrees celsius',
            output => '273.150 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '234 f to c' => test_zci(
        '234 degrees fahrenheit = 112.222 degrees celsius',
        structured_answer => {
            input => '234 degrees fahrenheit',
            output => "112.222 degrees celsius",
			physical_quantity => 'temperature'
        }
    ),
    '234 f to kelvin' => test_zci(
        '234 degrees fahrenheit = 385.372 kelvin',
        structured_answer => {
            input => '234 degrees fahrenheit',
            output => '385.372 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    'metres from 20 yards' => test_zci(
        '20 yards = 18.288 meters',
        structured_answer => {
            input => '20 yards',
            output => '18.288 meters',
			physical_quantity => 'length'
        }
    ),
    '7 milligrams to micrograms' => test_zci(
        '7 milligrams = 7,000 micrograms',
        structured_answer => {
            input => '7 milligrams',
            output => '7,000 micrograms',
			physical_quantity => 'mass'
        }
    ),
    'inches in 5 meters' => test_zci(
        '5 meters = 196.850 inches',
        structured_answer => {
            input => '5 meters',
            output => '196.850 inches',
			physical_quantity => 'length'
        }
    ),
    '5 inches in meters' => test_zci(
        '5 inches = 0.127 meters',
        structured_answer => {
            input => '5 inches',
            output => '0.127 meters',
			physical_quantity => 'length'
        }
    ),
    'millilitres in a gallon' => test_zci(
        '1 us gallon = 3,785.412 millilitres',
        structured_answer => {
            input => '1 us gallon',
            output => '3,785.412 millilitres',
			physical_quantity => 'volume'
        }
    ),
    'gallons in a millilitres' => test_zci(
        '1 millilitre = 0.000264 us gallons',
        structured_answer => {
            input => '1 millilitre',
            output => '0.000264 us gallons',
			physical_quantity => 'volume'
        }
    ),
    'feet in an inches' => test_zci(
        '1 inch = 0.083 feet',
        structured_answer => {
            input => '1 inch',
            output => '0.083 feet',
			physical_quantity => 'length'
        }
    ),
    'ml in gallons' => test_zci(
        '1 millilitre = 0.000264 us gallons',
        structured_answer => {
            input => '1 millilitre',
            output => '0.000264 us gallons',
			physical_quantity => 'volume'
        }
    ),
    'ml in gallon' => test_zci(
        '1 us gallon = 3,785.412 millilitres',
        structured_answer => {
            input => '1 us gallon',
            output => '3,785.412 millilitres',
			physical_quantity => 'volume'
        }
    ),
    '32 ml to oz' => test_zci(
        '32 millilitres = 1.082 us fluid ounces',
        structured_answer => {
            input => '32 millilitres',
            output => '1.082 us fluid ounces',
			physical_quantity => 'volume'
        }
    ),
    '100 oz to ml' => test_zci(
        '100 us fluid ounces = 2,957.353 millilitres',
        structured_answer => {
            input => '100 us fluid ounces',
            output => '2,957.353 millilitres',
			physical_quantity => 'volume'
        }
    ),
    '100 ml to oz' => test_zci(
        '100 millilitres = 3.381 us fluid ounces',
        structured_answer => {
            input => '100 millilitres',
            output => '3.381 us fluid ounces',
			physical_quantity => 'volume'
        }
    ),
    '75 ml to ounces' => test_zci(
        '75 millilitres = 2.536 us fluid ounces',
        structured_answer => {
            input => '75 millilitres',
            output => '2.536 us fluid ounces',
			physical_quantity => 'volume'
        }
    ),
    'mm in inches' => test_zci(
        '1 millimeter = 0.039 inches',
        structured_answer => {
            input => '1 millimeter',
            output => '0.039 inches',
			physical_quantity => 'length'
        }
    ),
    'mm in inch' => test_zci(
        '1 inch = 25.400 millimeters',
        structured_answer => {
            input => '1 inch',
            output => '25.400 millimeters',
			physical_quantity => 'length'
        }
    ),
    'how many fl oz in a cup' => test_zci (
        '1 us cup = 8 us fluid ounces',
        structured_answer => {
            input => '1 us cup',
            output => '8 us fluid ounces',
			physical_quantity => 'volume'
        }
    ),
    '4 cups in quarts' => test_zci(
        '4 us cups = 1 quart',
        structured_answer => {
            input => '4 us cups',
            output => '1 quart',
			physical_quantity => 'volume'
        }
    ),
    'how many ounces in a cup' => test_zci(
        '1 us cup = 8 us fluid ounces',
        structured_answer => {
            input => '1 us cup',
            output => '8 us fluid ounces',
			physical_quantity => 'volume'
        }
    ),
    # Unusual number formats
    '3e60 degrees in revolutions' => test_zci(
        '3 * 10^60 degrees = 8.33 * 10^57 revolutions',
        structured_answer => {
            input => '3 * 10<sup>60</sup> degrees',
            output => '8.33 * 10<sup>57</sup> revolutions',
			physical_quantity => 'angle'
        }
    ),
    '4,1E5 newtons to pounds force' => test_zci(
        '4,1 * 10^5 newtons = 92.171,667 pounds force',
        structured_answer => {
            input => '4,1 * 10<sup>5</sup> newtons',
            output => '92.171,667 pounds force',
			physical_quantity => 'force'
        }
    ),
    '4E5 newtons to pounds force' => test_zci(
        '4 * 10^5 newtons = 89,923.577 pounds force',
        structured_answer => {
            input => '4 * 10<sup>5</sup> newtons',
            output => '89,923.577 pounds force',
			physical_quantity => 'force'
        }
    ),
    '5,0 GB to megabyte' => test_zci(
        '5,0 gigabytes = 5.000 megabytes',
        structured_answer => {
            input => '5,0 gigabytes',
            output => '5.000 megabytes',
			physical_quantity => 'information'
        }
    ),
    '3.5e-2 miles to inches' => test_zci(
        '3.5 * 10^-2 miles = 2,217.600 inches',
        structured_answer => {
            input => '3.5 * 10<sup>-2</sup> miles',
            output => '2,217.600 inches',
			physical_quantity => 'length'
        }
    ),
    # Areas and volumes
    '100 square metres in hectares' => test_zci(
        '100 square meters = 0.010 hectares',
        structured_answer => {
            input => '100 square meters',
            output => '0.010 hectares',
			physical_quantity => 'area'
        }
    ),
    '0.0001 hectares in square metres' => test_zci(
        '0.0001 hectares = 1 square meter',
        structured_answer => {
            input => '0.0001 hectares',
            output => '1 square meter',
			physical_quantity => 'area'
        }
    ),
    '5 sq mi in square meters' => test_zci(
        '5 square miles = 1.29 * 10^7 square meters',
        structured_answer => {
            input => '5 square miles',
            output => '1.29 * 10<sup>7</sup> square meters',
			physical_quantity => 'area'
        }
    ),
    '1 imperial gallon in litres' => test_zci(
        '1 imperial gallon = 4.546 litres',
        structured_answer => {
            input => '1 imperial gallon',
            output => '4.546 litres',
			physical_quantity => 'volume'
        }
    ),
    '0.001 litres in millilitres' => test_zci(
        '0.001 litres = 1 millilitre',
        structured_answer => {
            input => '0.001 litres',
            output => '1 millilitre',
			physical_quantity => 'volume'
        }
    ),
    '1 hectare in square metres' => test_zci(
        '1 hectare = 10,000 square meters',
        structured_answer => {
            input => '1 hectare',
            output => '10,000 square meters',
			physical_quantity => 'area'
        }
    ),
    '1 acre in square kilometers' => test_zci(
        '1 acre = 0.004 square kilometers',
        structured_answer => {
            input => '1 acre',
            output => '0.004 square kilometers',
			physical_quantity => 'area'
        }
    ),
    '1 acres in square meters' => test_zci(
        '1 acre = 4,046.873 square meters',
        structured_answer => {
            input => '1 acre',
            output => '4,046.873 square meters',
			physical_quantity => 'area'
        }
    ),
    # Question-style
    'what is 1 inch in cm' => test_zci(
        '1 inch = 2.540 centimeters',
        structured_answer => {
            input => '1 inch',
            output => '2.540 centimeters',
			physical_quantity => 'length'
        }
    ),
    'what are 10 yards in metres' => test_zci(
        '10 yards = 9.144 meters',
        structured_answer => {
            input => '10 yards',
            output => '9.144 meters',
			physical_quantity => 'length'
        }
    ),
    'how long is 42 days in mins' => test_zci(
        '42 days = 60,480 minutes',
        structured_answer => {
            input => '42 days',
            output => '60,480 minutes',
			physical_quantity => 'time'
        }
    ),
    'how much is 40 kelvin in celsius' => test_zci(
        '40 kelvin = -233.150 degrees celsius',
        structured_answer => {
            input => '40 kelvin',
            output => '-233.150 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    'how much is 40 kelvin in celsius?' => test_zci(
        '40 kelvin = -233.150 degrees celsius',
        structured_answer => {
            input => '40 kelvin',
            output => "-233.150 degrees celsius",
			physical_quantity => 'temperature'
        }
    ),
    'how many metres in 10 of yard?' => test_zci(
        '10 yards = 9.144 meters',
        structured_answer => {
            input => '10 yards',
            output => '9.144 meters',
			physical_quantity => 'length'
        }
    ),
    'how many metres in 10 yards?' => test_zci(
        '10 yards = 9.144 meters',
        structured_answer => {
            input => '10 yards',
            output => '9.144 meters',
			physical_quantity => 'length'
        }
    ),
    'how many pounds in 1 kilogram' => test_zci(
        '1 kilogram = 2.205 pounds',
        structured_answer => {
            input => '1 kilogram',
            output => '2.205 pounds',
			physical_quantity => 'mass'
        }
    ),
    'how many pounds in kilogram' => test_zci(
        '1 kilogram = 2.205 pounds',
        structured_answer => {
            input => '1 kilogram',
            output => '2.205 pounds',
			physical_quantity => 'mass'
        }
    ),
    'how many pounds in kilograms?' => test_zci(
        '1 pound = 0.454 kilograms',
        structured_answer => {
            input => '1 pound',
            output => '0.454 kilograms',
			physical_quantity => 'mass'
        }
    ),
    'how many cm in a metre?' => test_zci(
        '1 meter = 100 centimeters',
        structured_answer => {
            input => '1 meter',
            output => '100 centimeters',
			physical_quantity => 'length'
        }
    ),
    'how many cm in metres?' => test_zci(
        '1 centimeter = 0.010 meters',
        structured_answer => {
            input => '1 centimeter',
            output => '0.010 meters',
			physical_quantity => 'length'
        }
    ),
    'how many cm in an inch?' => test_zci(
        '1 inch = 2.540 centimeters',
        structured_answer => {
            input => '1 inch',
            output => '2.540 centimeters',
			physical_quantity => 'length'
        }
    ),
    'how much is a liter in gallons?' => test_zci(
        '1 litre = 0.264 us gallons',
        structured_answer => {
            input => '1 litre',
            output => '0.264 us gallons',
			physical_quantity => 'volume'
        }
    ),
    'how much is a gallon in litres?' => test_zci(
        '1 us gallon = 3.785 litres',
        structured_answer => {
            input => '1 us gallon',
            output => '3.785 litres',
			physical_quantity => 'volume'
        }
    ),
    'how many gallons in a litre' => test_zci(
        '1 litre = 0.264 us gallons',
        structured_answer => {
            input => '1 litre',
            output => '0.264 us gallons',
			physical_quantity => 'volume'
        }
    ),
    'number of cm in 100 m' => test_zci(
        '100 meters = 10,000 centimeters',
        structured_answer => {
            input => '100 meters',
            output => '10,000 centimeters',
			physical_quantity => 'length'
        }
    ),
    '1 acres in square kilometers' => test_zci(
        '1 acre = 0.004 square kilometers',
        structured_answer => {
            input => '1 acre',
            output => '0.004 square kilometers',
			physical_quantity => 'area'
        }
    ),
    '1 acres in square meters' => test_zci(
        '1 acre = 4,046.873 square meters',
        structured_answer => {
            input => '1 acre',
            output => '4,046.873 square meters',
			physical_quantity => 'area'
        }
    ),
    '-40 fahrenheit in celsius' => test_zci(
        '-40 degrees fahrenheit = -40 degrees celsius',
        structured_answer => {
            input => '-40 degrees fahrenheit',
            output => '-40 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '-40 celsius in fahrenheit' => test_zci(
        '-40 degrees celsius = -40 degrees fahrenheit',
        structured_answer => {
            input => '-40 degrees celsius',
            output => '-40 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    
    ## Full suite of tests around temperatures
    # for computational accuracy rather than
    # parsing accuracy
    '10 fahrenheit in fahrenheit' => test_zci(
        '10 degrees fahrenheit = 10 degrees fahrenheit',
        structured_answer => {
            input => '10 degrees fahrenheit',
            output => '10 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '10 celsius in fahrenheit' => test_zci(
        '10 degrees celsius = 50 degrees fahrenheit',
        structured_answer => {
            input => '10 degrees celsius',
            output => '50 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '10 kelvin in fahrenheit' => test_zci(
        '10 kelvin = -441.670 degrees fahrenheit',
        structured_answer => {
            input => '10 kelvin',
            output => '-441.670 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '10 rankine in fahrenheit' => test_zci(
        '10 degrees rankine = -449.670 degrees fahrenheit',
        structured_answer => {
            input => '10 degrees rankine',
            output => '-449.670 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '1234 fahrenheit in fahrenheit' => test_zci(
        '1,234 degrees fahrenheit = 1,234 degrees fahrenheit',
        structured_answer => {
            input => '1,234 degrees fahrenheit',
            output => '1,234 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '1234 celsius in fahrenheit' => test_zci(
        '1,234 degrees celsius = 2,253.200 degrees fahrenheit',
        structured_answer => {
            input => '1,234 degrees celsius',
            output => '2,253.200 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '1234 kelvin in fahrenheit' => test_zci(
        '1,234 kelvin = 1,761.530 degrees fahrenheit',
        structured_answer => {
            input => '1,234 kelvin',
            output => '1,761.530 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '1234 rankine in fahrenheit' => test_zci(
        '1,234 degrees rankine = 774.330 degrees fahrenheit',
        structured_answer => {
            input => '1,234 degrees rankine',
            output => '774.330 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '-87 fahrenheit in fahrenheit' => test_zci(
        '-87 degrees fahrenheit = -87 degrees fahrenheit',
        structured_answer => {
            input => '-87 degrees fahrenheit',
            output => '-87 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '-87 celsius in fahrenheit' => test_zci(
        '-87 degrees celsius = -124.600 degrees fahrenheit',        
        structured_answer => {
            input => '-87 degrees celsius',
            output => '-124.600 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '-87 kelvin in fahrenheit' => undef,
    '-87 rankine in fahrenheit' => undef,
    '-7 fahrenheit in fahrenheit' => test_zci(
        '-7 degrees fahrenheit = -7 degrees fahrenheit',
        structured_answer => {
            input => '-7 degrees fahrenheit',
            output => '-7 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '-7 celsius in fahrenheit' => test_zci(
        '-7 degrees celsius = 19.400 degrees fahrenheit',
        structured_answer => {
            input => '-7 degrees celsius',
            output => '19.400 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '-7 kelvin in fahrenheit' => undef,
    '-7 rankine in fahrenheit' => undef,
    
    '0 fahrenheit in fahrenheit' => test_zci(
        '0 degrees fahrenheit = 0 degrees fahrenheit',
        structured_answer => {
            input => '0 degrees fahrenheit',
            output => '0 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),,
    '0 celsius in fahrenheit' => test_zci(
        '0 degrees celsius = 32 degrees fahrenheit',
        structured_answer => {
            input => '0 degrees celsius',
            output => '32 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '0 kelvin in fahrenheit' => test_zci(
        '0 kelvin = -459.670 degrees fahrenheit',
        structured_answer => {
            input => '0 kelvin',
            output => '-459.670 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '0 rankine in fahrenheit' => test_zci(
        '0 degrees rankine = -459.670 degrees fahrenheit',
        structured_answer => {
            input => '0 degrees rankine',
            output => '-459.670 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '10 fahrenheit in celsius' => test_zci(
        '10 degrees fahrenheit = -12.222 degrees celsius',
        structured_answer => {
            input => '10 degrees fahrenheit',
            output => '-12.222 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '10 celsius in celsius' => test_zci(
        '10 degrees celsius = 10 degrees celsius',
        structured_answer => {
            input => '10 degrees celsius',
            output => '10 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '10 kelvin in celsius' => test_zci(
        '10 kelvin = -263.150 degrees celsius',
        structured_answer => {
            input => '10 kelvin',
            output => '-263.150 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '10 rankine in celsius' => test_zci(
        '10 degrees rankine = -267.594 degrees celsius',
        structured_answer => {
            input => '10 degrees rankine',
            output => '-267.594 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    
    '1234 fahrenheit in celsius' => test_zci(
        '1,234 degrees fahrenheit = 667.778 degrees celsius',
        structured_answer => {
            input => '1,234 degrees fahrenheit',
            output => '667.778 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '1234 celsius in celsius' => test_zci(
        '1,234 degrees celsius = 1,234 degrees celsius',
        structured_answer => {
            input => '1,234 degrees celsius',
            output => '1,234 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '1234 kelvin in celsius' => test_zci(
        '1,234 kelvin = 960.850 degrees celsius',
        structured_answer => {
            input => '1,234 kelvin',
            output => '960.850 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '1234 rankine in celsius' => test_zci(
        '1,234 degrees rankine = 412.406 degrees celsius',
        structured_answer => {
            input => '1,234 degrees rankine',
            output => '412.406 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '-87 fahrenheit in celsius' => test_zci(
        '-87 degrees fahrenheit = -66.111 degrees celsius',
        structured_answer => {
            input => '-87 degrees fahrenheit',
            output => '-66.111 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '-87 celsius in celsius' => test_zci(
        '-87 degrees celsius = -87 degrees celsius',
        structured_answer => {
            input => '-87 degrees celsius',
            output => '-87 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '-87 kelvin in celsius' => undef,
    '-87 rankine in celsius' => undef,
    '-7 fahrenheit in celsius' => test_zci(
        '-7 degrees fahrenheit = -21.667 degrees celsius',
        structured_answer => {
            input => '-7 degrees fahrenheit',
            output => '-21.667 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '-7 celsius in celsius' => test_zci(
        '-7 degrees celsius = -7 degrees celsius',
        structured_answer => {
            input => '-7 degrees celsius',
            output => '-7 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '-7 kelvin in celsius' => undef,
    '-7 rankine in celsius' => undef,
    '0 fahrenheit in celsius' => test_zci(
        '0 degrees fahrenheit = -17.778 degrees celsius',
        structured_answer => {
            input => '0 degrees fahrenheit',
            output => '-17.778 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '0 celsius in celsius' => test_zci(
        '0 degrees celsius = 0 degrees celsius',
        structured_answer => {
            input => '0 degrees celsius',
            output => '0 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),,
    '0 kelvin in celsius' => test_zci(
        '0 kelvin = -273.150 degrees celsius',
        structured_answer => {
            input => '0 kelvin',
            output => '-273.150 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '0 rankine in celsius' => test_zci(
        '0 degrees rankine = -273.150 degrees celsius',
        structured_answer => {
            input => '0 degrees rankine',
            output => '-273.150 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '10 fahrenheit in kelvin' => test_zci(
        '10 degrees fahrenheit = 260.928 kelvin',
        structured_answer => {
            input => '10 degrees fahrenheit',
            output => '260.928 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '10 celsius in kelvin' => test_zci(
        '10 degrees celsius = 283.150 kelvin',
        structured_answer => {
            input => '10 degrees celsius',
            output => '283.150 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '10 kelvin in kelvin' => test_zci(
        '10 kelvin = 10 kelvin',
        structured_answer => {
            input => '10 kelvin',
            output => '10 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '10 rankine in kelvin' => test_zci(
        '10 degrees rankine = 5.556 kelvin',
        structured_answer => {
            input => '10 degrees rankine',
            output => '5.556 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '1234 fahrenheit in kelvin' => test_zci(
        '1,234 degrees fahrenheit = 940.928 kelvin',
        structured_answer => {
            input => '1,234 degrees fahrenheit',
            output => '940.928 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '1234 celsius in kelvin' => test_zci(
        '1,234 degrees celsius = 1,507.150 kelvin',
        structured_answer => {
            input => '1,234 degrees celsius',
            output => '1,507.150 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '1234 kelvin in kelvin' => test_zci(
        '1,234 kelvin = 1,234 kelvin',
        structured_answer => {
            input => '1,234 kelvin',
            output => '1,234 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '1234 rankine in kelvin' => test_zci(
        '1,234 degrees rankine = 685.556 kelvin',
        structured_answer => {
            input => '1,234 degrees rankine',
            output => '685.556 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '-87 fahrenheit in kelvin' => test_zci(
        '-87 degrees fahrenheit = 207.039 kelvin',
        structured_answer => {
            input => '-87 degrees fahrenheit',
            output => '207.039 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '-87 celsius in kelvin' => test_zci(
        '-87 degrees celsius = 186.150 kelvin',
        structured_answer => {
            input => '-87 degrees celsius',
            output => '186.150 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '-87 kelvin in kelvin' => undef,
    '-87 rankine in kelvin' => undef,
    
    '-7 fahrenheit in kelvin' => test_zci(
        '-7 degrees fahrenheit = 251.483 kelvin',
        structured_answer => {
            input => '-7 degrees fahrenheit',
            output => '251.483 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '-7 celsius in kelvin' => test_zci(
        '-7 degrees celsius = 266.150 kelvin',
        structured_answer => {
            input => '-7 degrees celsius',
            output => '266.150 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '-7 kelvin in kelvin' => undef,
    '-7 rankine in kelvin' => undef,
    '0 fahrenheit in kelvin' => test_zci(
        '0 degrees fahrenheit = 255.372 kelvin',
        structured_answer => {
            input => '0 degrees fahrenheit',
            output => '255.372 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '0 celsius in kelvin' => test_zci(
        '0 degrees celsius = 273.150 kelvin',
        structured_answer => {
            input => '0 degrees celsius',
            output => '273.150 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '0 kelvin in kelvin' => test_zci(
        '0 kelvin = 0 kelvin',
        structured_answer => {
            input => '0 kelvin',
            output => '0 kelvin',
			physical_quantity => 'temperature'
        }
    ),,
    '0 rankine in kelvin' => test_zci(
        '0 degrees rankine = 0 kelvin',
        structured_answer => {
            input => '0 degrees rankine',
            output => '0 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    
    '10 fahrenheit in rankine' => test_zci(
        '10 degrees fahrenheit = 469.670 degrees rankine',
        structured_answer => {
            input => '10 degrees fahrenheit',
            output => '469.670 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '10 celsius in rankine' => test_zci(
        '10 degrees celsius = 509.670 degrees rankine',        
        structured_answer => {
            input => '10 degrees celsius',
            output => '509.670 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '10 kelvin in rankine' => test_zci(
        '10 kelvin = 18 degrees rankine',
        structured_answer => {
            input => '10 kelvin',
            output => '18 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '10 rankine in rankine' => test_zci(
        '10 degrees rankine = 10 degrees rankine',
        structured_answer => {
            input => '10 degrees rankine',
            output => '10 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '1234 fahrenheit in rankine' => test_zci(
        '1,234 degrees fahrenheit = 1,693.670 degrees rankine',
        structured_answer => {
            input => '1,234 degrees fahrenheit',
            output => '1,693.670 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '1234 celsius in rankine' => test_zci(
        '1,234 degrees celsius = 2,712.870 degrees rankine',
        structured_answer => {
            input => '1,234 degrees celsius',
            output => '2,712.870 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '1234 kelvin in rankine' => test_zci(
        '1,234 kelvin = 2,221.200 degrees rankine',
        structured_answer => {
            input => '1,234 kelvin',
            output => '2,221.200 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '1234 rankine in rankine' => test_zci(
        '1,234 degrees rankine = 1,234 degrees rankine',
        structured_answer => {
            input => '1,234 degrees rankine',
            output => '1,234 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '-87 fahrenheit in rankine' => test_zci(
        '-87 degrees fahrenheit = 372.670 degrees rankine',
        structured_answer => {
            input => '-87 degrees fahrenheit',
            output => '372.670 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '-87 celsius in rankine' => test_zci(
        '-87 degrees celsius = 335.070 degrees rankine',
        structured_answer => {
            input => '-87 degrees celsius',
            output => '335.070 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '-87 kelvin in rankine' => undef,
    '-87 rankine in rankine' => undef,
    '-7 fahrenheit in rankine' => test_zci(
        '-7 degrees fahrenheit = 452.670 degrees rankine',
        structured_answer => {
            input => '-7 degrees fahrenheit',
            output => '452.670 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '-7 celsius in rankine' => test_zci(
        '-7 degrees celsius = 479.070 degrees rankine',
        structured_answer => {
            input => '-7 degrees celsius',
            output => '479.070 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '-7 kelvin in rankine' => undef,
    '-7 rankine in rankine' => undef,
    '0 fahrenheit in rankine' => test_zci(
        '0 degrees fahrenheit = 459.670 degrees rankine',
        structured_answer => {
            input => '0 degrees fahrenheit',
            output => '459.670 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '0 celsius in rankine' => test_zci(
        '0 degrees celsius = 491.670 degrees rankine',
        structured_answer => {
            input => '0 degrees celsius',
            output => '491.670 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '0 kelvin in rankine' => test_zci(
        '0 kelvin = 0 degrees rankine',
        structured_answer => {
            input => '0 kelvin',
            output => '0 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '0 rankine in rankine' => test_zci(
        '0 degrees rankine = 0 degrees rankine',
        structured_answer => {
            input => '0 degrees rankine',
            output => '0 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),,
        
    '84856 fahrenheit in fahrenheit' => test_zci(
        '84,856 degrees fahrenheit = 84,856 degrees fahrenheit',
        structured_answer => {
            input => '84,856 degrees fahrenheit',
            output => '84,856 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '84856 celsius in fahrenheit' => test_zci(
        '84,856 degrees celsius = 152,772.800 degrees fahrenheit',
        structured_answer => {
            input => '84,856 degrees celsius',
            output => '152,772.800 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '84856 kelvin in fahrenheit' => test_zci(
        '84,856 kelvin = 152,281.130 degrees fahrenheit',
        structured_answer => {
            input => '84,856 kelvin',
            output => '152,281.130 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '84856 rankine in fahrenheit' => test_zci(
        '84,856 degrees rankine = 84,396.330 degrees fahrenheit',
        structured_answer => {
            input => '84,856 degrees rankine',
            output => '84,396.330 degrees fahrenheit',
			physical_quantity => 'temperature'
        }
    ),
    '84856 fahrenheit in celsius' => test_zci(
        '84,856 degrees fahrenheit = 47,124.444 degrees celsius',
        structured_answer => {
            input => '84,856 degrees fahrenheit',
            output => '47,124.444 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '84856 celsius in celsius' => test_zci(
        '84,856 degrees celsius = 84,856 degrees celsius',
        structured_answer => {
            input => '84,856 degrees celsius',
            output => '84,856 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '84856 kelvin in celsius' => test_zci(
        '84,856 kelvin = 84,582.850 degrees celsius',
        structured_answer => {
            input => '84,856 kelvin',
            output => '84,582.850 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '84856 rankine in celsius' => test_zci(
        '84,856 degrees rankine = 46,869.072 degrees celsius',
        structured_answer => {
            input => '84,856 degrees rankine',
            output => '46,869.072 degrees celsius',
			physical_quantity => 'temperature'
        }
    ),
    '84856 fahrenheit in kelvin' => test_zci(
        '84,856 degrees fahrenheit = 47,397.594 kelvin',
        structured_answer => {
            input => '84,856 degrees fahrenheit',
            output => '47,397.594 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '84856 celsius in kelvin' => test_zci(
        '84,856 degrees celsius = 85,129.150 kelvin',
        structured_answer => {
            input => '84,856 degrees celsius',
            output => '85,129.150 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '84856 kelvin in kelvin' => test_zci(
        '84,856 kelvin = 84,856 kelvin',
        structured_answer => {
            input => '84,856 kelvin',
            output => '84,856 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '84856 rankine in kelvin' => test_zci(
        '84,856 degrees rankine = 47,142.222 kelvin',
        structured_answer => {
            input => '84,856 degrees rankine',
            output => '47,142.222 kelvin',
			physical_quantity => 'temperature'
        }
    ),
    '84856 fahrenheit in rankine' => test_zci(
        '84,856 degrees fahrenheit = 85,315.670 degrees rankine',
        structured_answer => {
            input => '84,856 degrees fahrenheit',
            output => '85,315.670 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '84856 celsius in rankine' => test_zci(
        '84,856 degrees celsius = 153,232.470 degrees rankine',
        structured_answer => {
            input => '84,856 degrees celsius',
            output => '153,232.470 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '84856 kelvin in rankine' => test_zci(
        '84,856 kelvin = 152,740.800 degrees rankine',
        structured_answer => {
            input => '84,856 kelvin',
            output => '152,740.800 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    '84856 rankine in rankine' => test_zci(
        '84,856 degrees rankine = 84,856 degrees rankine',
        structured_answer => {
            input => '84,856 degrees rankine',
            output => '84,856 degrees rankine',
			physical_quantity => 'temperature'
        }
    ),
    
    #Question format:
    'How to convert meters to inches' => test_zci(
        '1 meter = 39.370 inches',
        structured_answer => {
            input => '1 meter',
            output => '39.370 inches',
			physical_quantity => 'length'
        }
    ),
    '250 feet to inches' => test_zci(
        '250 feet = 3,000 inches',
        structured_answer => {
            input => '250 feet',
            output => '3,000 inches',
			physical_quantity => 'length'
        }
    ),
    # Representation (scientific notation)
    '30000 km to m' => test_zci(
        '30,000 kilometers = 3 * 10^7 meters',
        structured_answer => {
            input => ['30,000 kilometers'],
            operation => 'convert',
            result => '3 * 10<sup>7</sup> meters'
        }
    ),
    '3000000000000000 km to m' => test_zci(
        '3 * 10^15 kilometers = 3 * 10^18 meters',
        structured_answer => {
            input => ['3 * 10<sup>15</sup> kilometers'],
            operation => 'convert',
            result => '3 * 10<sup>18</sup> meters'
        }
    ),
    '3000 km to m' => test_zci(
        '3,000 kilometers = 3 * 10^6 meters',
        structured_answer => {
            input => ['3,000 kilometers'],
            operation => 'convert',
            result => '3 * 10<sup>6</sup> meters'
        }
    ),
    '300000000000 km to m' => test_zci(
        '3 * 10^11 kilometers = 3 * 10^14 meters',
        structured_answer => {
            input => ['3 * 10<sup>11</sup> kilometers'],
            operation => 'convert',
            result => '3 * 10<sup>14</sup> meters'
        }
    ),
    '4e-15 km to mm' => test_zci(
        '4 * 10^-15 kilometers = 4 * 10^-9 millimeters',
        structured_answer => {
            input => ['4 * 10<sup>-15</sup> kilometers'],
            operation => 'convert',
            result => '4 * 10<sup>-9</sup> millimeters'
        }
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
);
done_testing;
