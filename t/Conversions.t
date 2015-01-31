#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'conversions';
zci is_cached   => 1;

ddg_goodie_test(
    ['DDG::Goodie::Conversions'],
    # Example queries
    'convert 5 oz to grams' => test_zci(
        '5 ounces = 141.747 grams',
        structured_answer => {
            input     => ['5 ounces'],
            operation => 'Convert',
            result    => '141.747 grams'
        }
    ),
    '5 ounces to g' => test_zci(
        '5 ounces = 141.747 grams',
        structured_answer => {
            input     => ['5 ounces'],
            operation => 'Convert',
            result    => '141.747 grams'
        }
    ),
    '0.5 nautical miles in km' => test_zci(
        '0.5 nautical miles = 0.926 kilometers',
        structured_answer => {
            input     => ['0.5 nautical miles'],
            operation => 'Convert',
            result    => '0.926 kilometers'
        }
    ),
    # Explicit conversion requests
    'convert 1 ton to long ton' => test_zci(
        '1 ton = 0.893 long tons',
        structured_answer => {
            input     => ['1 ton'],
            operation => 'Convert',
            result    => '0.893 long tons'
        }
    ),
    'convert 158 ounce to lbm' => test_zci(
        '158 ounces = 9.875 pounds',
        structured_answer => {
            input     => ['158 ounces'],
            operation => 'Convert',
            result    => '9.875 pounds'
        }
    ),
    'convert 0.111 stone to pound' => test_zci(
        '0.111 stone = 1.554 pounds',
        structured_answer => {
            input     => ['0.111 stone'],
            operation => 'Convert',
            result    => '1.554 pounds'
        }
    ),
    'convert 5 feet to in' => test_zci(
        '5 feet = 60 inches',
        structured_answer => {
            input     => ['5 feet'],
            operation => 'Convert',
            result    => '60 inches'
        }
    ),
    'convert 5 kelvin to fahrenheit' => test_zci(
        '5 kelvin = -450.670 degrees fahrenheit',
        structured_answer => {
            input     => ['5 kelvin'],
            operation => 'Convert',
            result    => '-450.670 degrees fahrenheit'
        }
    ),
    'convert 25 inches into feet' => test_zci(
        '25 inches = 2.083 feet',
        structured_answer => {
            input     => ['25 inches'],
            operation => 'Convert',
            result    => '2.083 feet'
        }
    ),
    'convert 5 f to celsius' => test_zci(
        '5 degrees fahrenheit = -15 degrees celsius',
        structured_answer => {
            input     => ['5 degrees fahrenheit'],
            operation => 'Convert',
            result    => '-15 degrees celsius'
        }
    ),
    'convert km to cm' => test_zci(
        '1 kilometer = 100,000 centimeters',
        structured_answer => {
            input     => ['1 kilometer'],
            operation => 'Convert',
            result    => '100,000 centimeters'
        }
    ),
    'convert 10ms to seconds' => test_zci(
        '10 milliseconds = 0.010 seconds',
        structured_answer => {
            input     => ['10 milliseconds'],
            operation => 'Convert',
            result    => '0.010 seconds'
        }
    ),
    'convert 1 yb to yib' => test_zci(
        '1 yottabyte = 0.827 yobibytes',
        structured_answer => {
            input     => ['1 yottabyte'],
            operation => 'Convert',
            result    => '0.827 yobibytes'
        }
    ),
    'convert 1stone to lbs' => test_zci(
        '1 stone = 14 pounds',
        structured_answer => {
            input     => ['1 stone'],
            operation => 'Convert',
            result    => '14 pounds'
        }
    ),
    'convert 5 bytes to bit' => test_zci(
        '5 bytes = 40 bits',
        structured_answer => {
            input     => ['5 bytes'],
            operation => 'Convert',
            result    => '40 bits'
        }
    ),
    # Implicit conversion requests
    '3 kilogramme to pound' => test_zci(
        '3 kilograms = 6.614 pounds',
        structured_answer => {
            input     => ['3 kilograms'],
            operation => 'Convert',
            result    => '6.614 pounds'
        }
    ),
    '1.3 tonnes to ton' => test_zci(
        '1.3 metric tons = 1.433 tons',
        structured_answer => {
            input     => ['1.3 metric tons'],
            operation => 'Convert',
            result    => '1.433 tons'
        }
    ),
    '2 tons to kg' => test_zci(
        '2 tons = 1,814.372 kilograms',
        structured_answer => {
            input     => ['2 tons'],
            operation => 'Convert',
            result    => '1,814.372 kilograms'
        }
    ),
    '1 ton to kilos' => test_zci(
        '1 ton = 907.186 kilograms',
        structured_answer => {
            input     => ['1 ton'],
            operation => 'Convert',
            result    => '907.186 kilograms'
        }
    ),
    '3.9 oz in g' => test_zci(
        '3.9 ounces = 110.563 grams',
        structured_answer => {
            input     => ['3.9 ounces'],
            operation => 'Convert',
            result    => '110.563 grams'
        }
    ),
    '2 miles to km' => test_zci(
        '2 miles = 3.219 kilometers',
        structured_answer => {
            input     => ['2 miles'],
            operation => 'Convert',
            result    => '3.219 kilometers'
        }
    ),
    '0.5 nautical mile to klick' => test_zci(
        '0.5 nautical miles = 0.926 kilometers',
        structured_answer => {
            input     => ['0.5 nautical miles'],
            operation => 'Convert',
            result    => '0.926 kilometers'
        }
    ),
    '500 miles in metres' => test_zci(
        '500 miles = 804,672.249 meters',
        structured_answer => {
            input     => ['500 miles'],
            operation => 'Convert',
            result    => '804,672.249 meters'
        }
    ),
    '25 cm in inches' => test_zci(
        '25 centimeters = 9.843 inches',
        structured_answer => {
            input     => ['25 centimeters'],
            operation => 'Convert',
            result    => '9.843 inches'
        }
    ),
    '1760 yards to miles' => test_zci(
        '1,760 yards = 1 mile',
        structured_answer => {
            input     => ['1,760 yards'],
            operation => 'Convert',
            result    => '1 mile'
        }
    ),
    '3520yards to miles' => test_zci(
        '3,520 yards = 2 miles',
        structured_answer => {
            input     => ['3,520 yards'],
            operation => 'Convert',
            result    => '2 miles'
        }
    ),
    '30cm in in' => test_zci(
        '30 centimeters = 11.811 inches',
        structured_answer => {
            input     => ['30 centimeters'],
            operation => 'Convert',
            result    => '11.811 inches'
        }
    ),
    '36 months to years' => test_zci(
        '36 months = 3 years',
        structured_answer => {
            input     => ['36 months'],
            operation => 'Convert',
            result    => '3 years'
        }
    ),
    '43200 seconds in hours' => test_zci(
        '43,200 seconds = 12 hours',
        structured_answer => {
            input     => ['43,200 seconds'],
            operation => 'Convert',
            result    => '12 hours'
        }
    ),
    '4 hours to minutes' => test_zci(
        '4 hours = 240 minutes',
        structured_answer => {
            input     => ['4 hours'],
            operation => 'Convert',
            result    => '240 minutes'
        }
    ),
    '1 bar to pascal' => test_zci(
        '1 bar = 100,000 pascals',
        structured_answer => {
            input     => ['1 bar'],
            operation => 'Convert',
            result    => '100,000 pascals'
        }
    ),
    '1 kilopascal to psi' => test_zci(
        '1 kilopascal = 0.145 pounds per square inch',
        structured_answer => {
            input     => ['1 kilopascal'],
            operation => 'Convert',
            result    => '0.145 pounds per square inch'
        }
    ),
    '1 atm to kpa' => test_zci(
        '1 atmosphere = 101.325 kilopascals',
        structured_answer => {
            input     => ['1 atmosphere'],
            operation => 'Convert',
            result    => '101.325 kilopascals'
        }
    ),
    '5yrds to km' => test_zci(
        '5 yards = 0.005 kilometers',
        structured_answer => {
            input     => ['5 yards'],
            operation => 'Convert',
            result    => '0.005 kilometers'
        }
    ),
    '12" to cm' => test_zci(
        '12 inches = 30.480 centimeters',
        structured_answer => {
            input     => ['12 inches'],
            operation => 'Convert',
            result    => '30.480 centimeters'
        }
    ),
    '42 kilowatt hours in joules' => test_zci(
        '42 kilowatt-hours = 1.51 * 10^8 joules',
        structured_answer => {
            input     => ['42 kilowatt-hours'],
            operation => 'Convert',
            result    => '1.51 * 10<sup>8</sup> joules'
        }
    ),
    '2500kcal in tons of tnt' => test_zci(
        '2,500 large calories = 0.003 tons of TNT',
        structured_answer => {
            input     => ['2,500 large calories'],
            operation => 'Convert',
            result    => '0.003 tons of TNT'
        }
    ),
    '90 ps in watts' => test_zci(
        '90 metric horsepower = 66,194.888 watts',
        structured_answer => {
            input     => ['90 metric horsepower'],
            operation => 'Convert',
            result    => '66,194.888 watts'
        }
    ),
    '1 gigawatt in horsepower' => test_zci(
        '1 gigawatt = 1.34 * 10^6 horsepower',
        structured_answer => {
            input     => ['1 gigawatt'],
            operation => 'Convert',
            result    => '1.34 * 10<sup>6</sup> horsepower'
        }
    ),
    '180 degrees in radians' => test_zci(
        '180 degrees = 3.142 radians',
        structured_answer => {
            input     => ['180 degrees'],
            operation => 'Convert',
            result    => '3.142 radians'
        }
    ),
    '270 degrees in quadrants' => test_zci(
        '270 degrees = 3 quadrants',
        structured_answer => {
            input     => ['270 degrees'],
            operation => 'Convert',
            result    => '3 quadrants'
        }
    ),
    '180 degrees in grads' => test_zci(
        '180 degrees = 200 gradians',
        structured_answer => {
            input     => ['180 degrees'],
            operation => 'Convert',
            result    => '200 gradians'
        }
    ),
    '45 newtons to pounds force' => test_zci(
        '45 newtons = 10.116 pounds force',
        structured_answer => {
            input     => ['45 newtons'],
            operation => 'Convert',
            result    => '10.116 pounds force'
        }
    ),
    '8 poundal to newtons' => test_zci(
        '8 poundals = 1.106 newtons',
        structured_answer => {
            input     => ['8 poundals'],
            operation => 'Convert',
            result    => '1.106 newtons'
        }
    ),
    '10 mg to tons' => test_zci(
        '10 milligrams = 1.1 * 10^-8 tons',
        structured_answer => {
            input     => ['10 milligrams'],
            operation => 'Convert',
            result    => '1.1 * 10<sup>-8</sup> tons'
        }
    ),
    '10000 minutes in microseconds' => test_zci(
        '10,000 minutes = 6 * 10^11 microseconds',
        structured_answer => {
            input     => ['10,000 minutes'],
            operation => 'Convert',
            result    => '6 * 10<sup>11</sup> microseconds'
        }
    ),
    '5 GB to megabyte' => test_zci(
        '5 gigabytes = 5,000 megabytes',
        structured_answer => {
            input     => ['5 gigabytes'],
            operation => 'Convert',
            result    => '5,000 megabytes'
        }
    ),
    '0.013 mb in bits' => test_zci(
        '0.013 megabytes = 104,000 bits',
        structured_answer => {
            input     => ['0.013 megabytes'],
            operation => 'Convert',
            result    => '104,000 bits'
        }
    ),
    '0,013 mb in bits' => test_zci(
        '0,013 megabytes = 104.000 bits',
        structured_answer => {
            input     => ['0,013 megabytes'],
            operation => 'Convert',
            result    => '104.000 bits'
        }
    ),
    '1 exabyte to pib' => test_zci(
        '1 exabyte = 888.178 pebibytes',
        structured_answer => {
            input     => ['1 exabyte'],
            operation => 'Convert',
            result    => '888.178 pebibytes'
        }
    ),
    '16 years in months' => test_zci(
        '16 years = 192 months',
        structured_answer => {
            input     => ['16 years'],
            operation => 'Convert',
            result    => '192 months'
        }
    ),
    '1 year in months' => test_zci(
        '1 year = 12 months',
        structured_answer => {
            input     => ['1 year'],
            operation => 'Convert',
            result    => '12 months'
        }
    ),
    '360 degrees in revolutions' => test_zci(
        '360 degrees = 1 revolution',
        structured_answer => {
            input     => ['360 degrees'],
            operation => 'Convert',
            result    => '1 revolution'
        }
    ),
    '12 degrees Celsius to Fahrenheit' => test_zci(
        '12 degrees celsius = 53.600 degrees fahrenheit',
        structured_answer => {
            input     => ['12 degrees celsius'],
            operation => 'Convert',
            result    => '53.600 degrees fahrenheit'
        }
    ),
    '1 degrees Fahrenheit to celsius' => test_zci(
        '1 degree fahrenheit = -17.222 degrees celsius',
        structured_answer => {
            input     => ['1 degree fahrenheit'],
            operation => 'Convert',
            result    => '-17.222 degrees celsius'
        }
    ),
    '0 c in k' => test_zci(
        '0 degrees celsius = 273.150 kelvin',
        structured_answer => {
            input     => ['0 degrees celsius'],
            operation => 'Convert',
            result    => '273.150 kelvin'
        }
    ),
    '234 f to c' => test_zci(
        '234 degrees fahrenheit = 112.222 degrees celsius',
        structured_answer => {
            input     => ['234 degrees fahrenheit'],
            operation => 'Convert',
            result    => '112.222 degrees celsius'
        }
    ),
    '234 f to k' => test_zci(
        '234 degrees fahrenheit = 385.372 kelvin',
        structured_answer => {
            input     => ['234 degrees fahrenheit'],
            operation => 'Convert',
            result    => '385.372 kelvin'
        }
    ),
    'metres from 20 yards' => test_zci(
        '20 yards = 18.288 meters',
        structured_answer => {
            input     => ['20 yards'],
            operation => 'Convert',
            result    => '18.288 meters'
        }
    ),
    '7 milligrams to micrograms' => test_zci(
        '7 milligrams = 7,000 micrograms',
        structured_answer => {
            input     => ['7 milligrams'],
            operation => 'Convert',
            result    => '7,000 micrograms'
        }
    ),
    'inches in 5 meters' => test_zci(
        '5 meters = 196.851 inches',
        structured_answer => {
            input     => ['5 meters'],
            operation => 'Convert',
            result    => '196.851 inches'
        }
    ),
    '5 inches in meters' => test_zci(
        '5 inches = 0.127 meters',
        structured_answer => {
            input     => ['5 inches'],
            operation => 'Convert',
            result    => '0.127 meters'
        }
    ),
    'millilitres in a gallon' => test_zci(
        '1 us gallon = 3,785.412 millilitres',
        structured_answer => {
            input     => ['1 us gallon'],
            operation => 'Convert',
            result    => '3,785.412 millilitres'
        }
    ),
    'gallons in a millilitres' => test_zci(
        '1 millilitre = 0.000264 us gallons',
        structured_answer => {
            input     => ['1 millilitre'],
            operation => 'Convert',
            result    => '0.000264 us gallons'
        }
    ),
    'feet in an inches' => test_zci(
        '1 inch = 0.083 feet',
        structured_answer => {
            input     => ['1 inch'],
            operation => 'Convert',
            result    => '0.083 feet'
        }
    ),
    'ml in gallons' => test_zci(
        '1 millilitre = 0.000264 us gallons',
        structured_answer => {
            input     => ['1 millilitre'],
            operation => 'Convert',
            result    => '0.000264 us gallons'
        }
    ),
    'ml in gallon' => test_zci(
        '1 us gallon = 3,785.412 millilitres',
        structured_answer => {
            input     => ['1 us gallon'],
            operation => 'Convert',
            result    => '3,785.412 millilitres'
        }
    ),
    'mm in inches' => test_zci(
        '1 millimeter = 0.039 inches',
        structured_answer => {
            input     => ['1 millimeter'],
            operation => 'Convert',
            result    => '0.039 inches'
        }
    ),
    'mm in inch' => test_zci(
        '1 inch = 25.400 millimeters',
        structured_answer => {
            input     => ['1 inch'],
            operation => 'Convert',
            result    => '25.400 millimeters'
        }
    ),
    # Unusual number formats
    '3e60 degrees in revolutions' => test_zci(
        '3 * 10^60 degrees = 8.33 * 10^57 revolutions',
        structured_answer => {
            input     => ['3 * 10<sup>60</sup> degrees'],
            operation => 'Convert',
            result    => '8.33 * 10<sup>57</sup> revolutions'
        }
    ),
    '4,1E5 newtons to pounds force' => test_zci(
        '4,1 * 10^5 newtons = 92.171,667 pounds force',
        structured_answer => {
            input     => ['4,1 * 10<sup>5</sup> newtons'],
            operation => 'Convert',
            result    => '92.171,667 pounds force'
        }
    ),
    '4E5 newtons to pounds force' => test_zci(
        '4 * 10^5 newtons = 89,923.577 pounds force',
        structured_answer => {
            input     => ['4 * 10<sup>5</sup> newtons'],
            operation => 'Convert',
            result    => '89,923.577 pounds force'
        }
    ),
    '5,0 GB to megabyte' => test_zci(
        '5,0 gigabytes = 5.000 megabytes',
        structured_answer => {
            input     => ['5,0 gigabytes'],
            operation => 'Convert',
            result    => '5.000 megabytes'
        }
    ),
    '3.5e-2 miles to inches' => test_zci(
        '3.5 * 10^-2 miles = 2,217.602 inches',
        structured_answer => {
            input     => ['3.5 * 10<sup>-2</sup> miles'],
            operation => 'Convert',
            result    => '2,217.602 inches'
        }
    ),
    # Areas and volumes
    '100 square metres in hectares' => test_zci(
        '100 square meters = 0.010 hectares',
        structured_answer => {
            input     => ['100 square meters'],
            operation => 'Convert',
            result    => '0.010 hectares'
        }
    ),
    '0.0001 hectares in square metres' => test_zci(
        '0.0001 hectares = 1 square meter',
        structured_answer => {
            input     => ['0.0001 hectares'],
            operation => 'Convert',
            result    => '1 square meter'
        }
    ),
    '1 imperial gallon in litres' => test_zci(
        '1 imperial gallon = 4.546 litres',
        structured_answer => {
            input     => ['1 imperial gallon'],
            operation => 'Convert',
            result    => '4.546 litres'
        }
    ),
    '0.001 litres in millilitres' => test_zci(
        '0.001 litres = 1 millilitre',
        structured_answer => {
            input     => ['0.001 litres'],
            operation => 'Convert',
            result    => '1 millilitre'
        }
    ),
    '1 hectare in square metres' => test_zci(
        '1 hectare = 10,000 square meters',
        structured_answer => {
            input     => ['1 hectare'],
            operation => 'Convert',
            result    => '10,000 square meters'
        }
    ),
    '1 acre in square kilometers' => test_zci(
        '1 acre = 0.004 square kilometers',
        structured_answer => {
            input     => ['1 acre'],
            operation => 'Convert',
            result    => '0.004 square kilometers'
        }
    ),
    '1 acres in square meters' => test_zci(
        '1 acre = 4,046.873 square meters',
        structured_answer => {
            input     => ['1 acre'],
            operation => 'Convert',
            result    => '4,046.873 square meters'
        }
    ),
    # Question-style
    'what is 1 inch in cm' => test_zci(
        '1 inch = 2.540 centimeters',
        structured_answer => {
            input     => ['1 inch'],
            operation => 'Convert',
            result    => '2.540 centimeters'
        }
    ),
    'what are 10 yards in metres' => test_zci(
        '10 yards = 9.144 meters',
        structured_answer => {
            input     => ['10 yards'],
            operation => 'Convert',
            result    => '9.144 meters'
        }
    ),
    'how long is 42 days in mins' => test_zci(
        '42 days = 60,480 minutes',
        structured_answer => {
            input     => ['42 days'],
            operation => 'Convert',
            result    => '60,480 minutes'
        }
    ),
    'how much is 40 kelvin in celsius' => test_zci(
        '40 kelvin = -233.150 degrees celsius',
        structured_answer => {
            input     => ['40 kelvin'],
            operation => 'Convert',
            result    => '-233.150 degrees celsius'
        }
    ),
    'how much is 40 kelvin in celsius?' => test_zci(
        '40 kelvin = -233.150 degrees celsius',
        structured_answer => {
            input     => ['40 kelvin'],
            operation => 'Convert',
            result    => '-233.150 degrees celsius'
        }
    ),
    'how many metres in 10 of yard?' => test_zci(
        '10 yards = 9.144 meters',
        structured_answer => {
            input     => ['10 yards'],
            operation => 'Convert',
            result    => '9.144 meters'
        }
    ),
    'how many metres in 10 yards?' => test_zci(
        '10 yards = 9.144 meters',
        structured_answer => {
            input     => ['10 yards'],
            operation => 'Convert',
            result    => '9.144 meters'
        }
    ),
    'how many pounds in 1 kilogram' => test_zci(
        '1 kilogram = 2.205 pounds',
        structured_answer => {
            input     => ['1 kilogram'],
            operation => 'Convert',
            result    => '2.205 pounds'
        }
    ),
    'how many pounds in kilogram' => test_zci(
        '1 kilogram = 2.205 pounds',
        structured_answer => {
            input     => ['1 kilogram'],
            operation => 'Convert',
            result    => '2.205 pounds'
        }
    ),
    'how many pounds in kilograms?' => test_zci(
        '1 pound = 0.454 kilograms',
        structured_answer => {
            input     => ['1 pound'],
            operation => 'Convert',
            result    => '0.454 kilograms'
        }
    ),
    'how many cm in a metre?' => test_zci(
        '1 meter = 100 centimeters',
        structured_answer => {
            input     => ['1 meter'],
            operation => 'Convert',
            result    => '100 centimeters'
        }
    ),
    'how many cm in metres?' => test_zci(
        '1 centimeter = 0.010 meters',
        structured_answer => {
            input     => ['1 centimeter'],
            operation => 'Convert',
            result    => '0.010 meters'
        }
    ),
    'how many cm in an inch?' => test_zci(
        '1 inch = 2.540 centimeters',
        structured_answer => {
            input     => ['1 inch'],
            operation => 'Convert',
            result    => '2.540 centimeters'
        }
    ),
    'how much is a liter in gallons?' => test_zci(
        '1 litre = 0.264 us gallons',
        structured_answer => {
            input     => ['1 litre'],
            operation => 'Convert',
            result    => '0.264 us gallons'
        }
    ),
    'how much is a gallon in litres?' => test_zci(
        '1 us gallon = 3.785 litres',
        structured_answer => {
            input     => ['1 us gallon'],
            operation => 'Convert',
            result    => '3.785 litres'
        }
    ),
    'how many gallons in a litre' => test_zci(
        '1 litre = 0.264 us gallons',
        structured_answer => {
            input     => ['1 litre'],
            operation => 'Convert',
            result    => '0.264 us gallons'
        }
    ),
    'number of cm in 100 m' => test_zci(
        '100 meters = 10,000 centimeters',
        structured_answer => {
            input     => ['100 meters'],
            operation => 'Convert',
            result    => '10,000 centimeters'
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
