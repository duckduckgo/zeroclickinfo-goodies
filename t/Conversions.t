#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'conversions';

# Match the promotion to BigInt in the IA
use bignum;
zci is_cached   => 1;
no bignum;

ddg_goodie_test(
    ['DDG::Goodie::Conversions'],
    # Example queries
    'convert 5 oz to grams' => test_zci(
        '5 ounces = 141.747 grams',
        structured_answer => {
            input     => ['5 ounces'],
            operation => 'convert',
            result    => '141.747 grams'
        }
    ),
    '5 ounces to g' => test_zci(
        '5 ounces = 141.747 grams',
        structured_answer => {
            input     => ['5 ounces'],
            operation => 'convert',
            result    => '141.747 grams'
        }
    ),
    '0.5 nautical miles in km' => test_zci(
        '0.5 nautical miles = 0.926 kilometers',
        structured_answer => {
            input     => ['0.5 nautical miles'],
            operation => 'convert',
            result    => '0.926 kilometers'
        }
    ),
    # Explicit conversion requests
    'convert 1 ton to long ton' => test_zci(
        '1 ton = 0.893 long tons',
        structured_answer => {
            input     => ['1 ton'],
            operation => 'convert',
            result    => '0.893 long tons'
        }
    ),
    'convert 158 ounce to lbm' => test_zci(
        '158 ounces = 9.875 pounds',
        structured_answer => {
            input     => ['158 ounces'],
            operation => 'convert',
            result    => '9.875 pounds'
        }
    ),
    'convert 0.111 stone to pound' => test_zci(
        '0.111 stone = 1.554 pounds',
        structured_answer => {
            input     => ['0.111 stone'],
            operation => 'convert',
            result    => '1.554 pounds'
        }
    ),
    'convert 5 feet to in' => test_zci(
        '5 feet = 60 inches',
        structured_answer => {
            input     => ['5 feet'],
            operation => 'convert',
            result    => '60 inches'
        }
    ),
    'convert 5 kelvin to fahrenheit' => test_zci(
        '5 kelvin = -450.670 degrees fahrenheit',
        structured_answer => {
            input     => ['5 kelvin'],
            operation => 'convert',
            result    => "-450.670 degrees fahrenheit"
        }
    ),
    'light year to mm' => test_zci(
        '1 light year = 9.46 * 10^18 millimeters',
        structured_answer => {
            input     => ['1 light year'],
            operation => 'convert',
            result    => '9.46 * 10<sup>18</sup> millimeters'
        }
    ),
    'BTU to KwH' => test_zci(
        '1 british thermal unit = 0.000293 kilowatt-hours',
        structured_answer => {
            input     => ['1 british thermal unit'],
            operation => 'convert',
            result    => '0.000293 kilowatt-hours'
        }
    ),
    'convert 25 inches into feet' => test_zci(
        '25 inches = 2.083 feet',
        structured_answer => {
            input     => ['25 inches'],
            operation => 'convert',
            result    => '2.083 feet'
        }
    ),
    'convert 5 f to celsius' => test_zci(
        '5 degrees fahrenheit = -15 degrees celsius',
        structured_answer => {
            input     => ['5 degrees fahrenheit'],
            operation => 'convert',
            result    => "-15 degrees celsius"
        }
    ),
    'convert km to cm' => test_zci(
        '1 kilometer = 100,000 centimeters',
        structured_answer => {
            input     => ['1 kilometer'],
            operation => 'convert',
            result    => '100,000 centimeters'
        }
    ),
    'convert 10ms to seconds' => test_zci(
        '10 milliseconds = 0.010 seconds',
        structured_answer => {
            input     => ['10 milliseconds'],
            operation => 'convert',
            result    => '0.010 seconds'
        }
    ),
    'convert 1 yb to yib' => test_zci(
        '1 yottabyte = 0.827 yobibytes',
        structured_answer => {
            input     => ['1 yottabyte'],
            operation => 'convert',
            result    => '0.827 yobibytes'
        }
    ),
    'convert 1stone to lbs' => test_zci(
        '1 stone = 14 pounds',
        structured_answer => {
            input     => ['1 stone'],
            operation => 'convert',
            result    => '14 pounds'
        }
    ),
    'convert 5 bytes to bit' => test_zci(
        '5 bytes = 40 bits',
        structured_answer => {
            input     => ['5 bytes'],
            operation => 'convert',
            result    => '40 bits'
        }
    ),
    # Implicit conversion requests
    '3 kilogramme to pound' => test_zci(
        '3 kilograms = 6.614 pounds',
        structured_answer => {
            input     => ['3 kilograms'],
            operation => 'convert',
            result    => '6.614 pounds'
        }
    ),
    '1.3 tonnes to ton' => test_zci(
        '1.3 metric tons = 1.433 tons',
        structured_answer => {
            input     => ['1.3 metric tons'],
            operation => 'convert',
            result    => '1.433 tons'
        }
    ),
    '2 tons to kg' => test_zci(
        '2 tons = 1,814.372 kilograms',
        structured_answer => {
            input     => ['2 tons'],
            operation => 'convert',
            result    => '1,814.372 kilograms'
        }
    ),
    '1 ton to kilos' => test_zci(
        '1 ton = 907.186 kilograms',
        structured_answer => {
            input     => ['1 ton'],
            operation => 'convert',
            result    => '907.186 kilograms'
        }
    ),
    '3.9 oz in g' => test_zci(
        '3.9 ounces = 110.563 grams',
        structured_answer => {
            input     => ['3.9 ounces'],
            operation => 'convert',
            result    => '110.563 grams'
        }
    ),
    '2 miles to km' => test_zci(
        '2 miles = 3.219 kilometers',
        structured_answer => {
            input     => ['2 miles'],
            operation => 'convert',
            result    => '3.219 kilometers'
        }
    ),
    '3 mi to km' => test_zci(
        '3 miles = 4.828 kilometers',
        structured_answer => {
            input     => ['3 miles'],
            operation => 'convert',
            result    => '4.828 kilometers'
        }
    ),
    '0.5 nautical mile to klick' => test_zci(
        '0.5 nautical miles = 0.926 kilometers',
        structured_answer => {
            input     => ['0.5 nautical miles'],
            operation => 'convert',
            result    => '0.926 kilometers'
        }
    ),
    '500 miles in metres' => test_zci(
        '500 miles = 804,672 meters',
        structured_answer => {
            input     => ['500 miles'],
            operation => 'convert',
            result    => '804,672 meters'
        }
    ),
    '25 cm in inches' => test_zci(
        '25 centimeters = 9.843 inches',
        structured_answer => {
            input     => ['25 centimeters'],
            operation => 'convert',
            result    => '9.843 inches'
        }
    ),
    '1760 yards to miles' => test_zci(
        '1,760 yards = 1 mile',
        structured_answer => {
            input     => ['1,760 yards'],
            operation => 'convert',
            result    => '1 mile'
        }
    ),
    '3520yards to miles' => test_zci(
        '3,520 yards = 2 miles',
        structured_answer => {
            input     => ['3,520 yards'],
            operation => 'convert',
            result    => '2 miles'
        }
    ),
    '30cm in in' => test_zci(
        '30 centimeters = 11.811 inches',
        structured_answer => {
            input     => ['30 centimeters'],
            operation => 'convert',
            result    => '11.811 inches'
        }
    ),
    '36 months to years' => test_zci(
        '36 months = 3 years',
        structured_answer => {
            input     => ['36 months'],
            operation => 'convert',
            result    => '3 years'
        }
    ),
    '43200 seconds in hours' => test_zci(
        '43,200 seconds = 12 hours',
        structured_answer => {
            input     => ['43,200 seconds'],
            operation => 'convert',
            result    => '12 hours'
        }
    ),
    '4 hours to minutes' => test_zci(
        '4 hours = 240 minutes',
        structured_answer => {
            input     => ['4 hours'],
            operation => 'convert',
            result    => '240 minutes'
        }
    ),
    '1 bar to pascal' => test_zci(
        '1 bar = 100,000 pascals',
        structured_answer => {
            input     => ['1 bar'],
            operation => 'convert',
            result    => '100,000 pascals'
        }
    ),
    '1 kilopascal to psi' => test_zci(
        '1 kilopascal = 0.145 pounds per square inch',
        structured_answer => {
            input     => ['1 kilopascal'],
            operation => 'convert',
            result    => '0.145 pounds per square inch'
        }
    ),
    '1 atm to kpa' => test_zci(
        '1 atmosphere = 101.325 kilopascals',
        structured_answer => {
            input     => ['1 atmosphere'],
            operation => 'convert',
            result    => '101.325 kilopascals'
        }
    ),
    '5yrds to km' => test_zci(
        '5 yards = 0.005 kilometers',
        structured_answer => {
            input     => ['5 yards'],
            operation => 'convert',
            result    => '0.005 kilometers'
        }
    ),
    '12" to cm' => test_zci(
        '12 inches = 30.480 centimeters',
        structured_answer => {
            input     => ['12 inches'],
            operation => 'convert',
            result    => '30.480 centimeters'
        }
    ),
    '42 kilowatt hours in joules' => test_zci(
        '42 kilowatt-hours = 1.51 * 10^8 joules',
        structured_answer => {
            input     => ['42 kilowatt-hours'],
            operation => 'convert',
            result    => '1.51 * 10<sup>8</sup> joules'
        }
    ),
    '2500kcal in tons of tnt' => test_zci(
        '2,500 large calories = 0.003 tons of TNT',
        structured_answer => {
            input     => ['2,500 large calories'],
            operation => 'convert',
            result    => '0.003 tons of TNT'
        }
    ),
    '90 ps in watts' => test_zci(
        '90 metric horsepower = 66,194.888 watts',
        structured_answer => {
            input     => ['90 metric horsepower'],
            operation => 'convert',
            result    => '66,194.888 watts'
        }
    ),
    '1 gigawatt in horsepower' => test_zci(
        '1 gigawatt = 1.34 * 10^6 horsepower',
        structured_answer => {
            input     => ['1 gigawatt'],
            operation => 'convert',
            result    => '1.34 * 10<sup>6</sup> horsepower'
        }
    ),
    '180 degrees in radians' => test_zci(
        '180 degrees = 3.142 radians',
        structured_answer => {
            input     => ['180 degrees'],
            operation => 'convert',
            result    => '3.142 radians'
        }
    ),
    '270 degrees in quadrants' => test_zci(
        '270 degrees = 3 quadrants',
        structured_answer => {
            input     => ['270 degrees'],
            operation => 'convert',
            result    => '3 quadrants'
        }
    ),
    '180 degrees in grads' => test_zci(
        '180 degrees = 200 gradians',
        structured_answer => {
            input     => ['180 degrees'],
            operation => 'convert',
            result    => '200 gradians'
        }
    ),
    '45 newtons to pounds force' => test_zci(
        '45 newtons = 10.116 pounds force',
        structured_answer => {
            input     => ['45 newtons'],
            operation => 'convert',
            result    => '10.116 pounds force'
        }
    ),
    '8 poundal to newtons' => test_zci(
        '8 poundals = 1.106 newtons',
        structured_answer => {
            input     => ['8 poundals'],
            operation => 'convert',
            result    => '1.106 newtons'
        }
    ),
    '10 mg to tons' => test_zci(
        '10 milligrams = 1.1 * 10^-8 tons',
        structured_answer => {
            input     => ['10 milligrams'],
            operation => 'convert',
            result    => '1.1 * 10<sup>-8</sup> tons'
        }
    ),
    '10000 minutes in microseconds' => test_zci(
        '10,000 minutes = 6 * 10^11 microseconds',
        structured_answer => {
            input     => ['10,000 minutes'],
            operation => 'convert',
            result    => '6 * 10<sup>11</sup> microseconds'
        }
    ),
    '5 GB to megabyte' => test_zci(
        '5 gigabytes = 5,000 megabytes',
        structured_answer => {
            input     => ['5 gigabytes'],
            operation => 'convert',
            result    => '5,000 megabytes'
        }
    ),
    '0.013 mb in bits' => test_zci(
        '0.013 megabytes = 104,000 bits',
        structured_answer => {
            input     => ['0.013 megabytes'],
            operation => 'convert',
            result    => '104,000 bits'
        }
    ),
    '0,013 mb in bits' => test_zci(
        '0,013 megabytes = 104.000 bits',
        structured_answer => {
            input     => ['0,013 megabytes'],
            operation => 'convert',
            result    => '104.000 bits'
        }
    ),
    '1 exabyte to pib' => test_zci(
        '1 exabyte = 888.178 pebibytes',
        structured_answer => {
            input     => ['1 exabyte'],
            operation => 'convert',
            result    => '888.178 pebibytes'
        }
    ),
    '16 years in months' => test_zci(
        '16 years = 192 months',
        structured_answer => {
            input     => ['16 years'],
            operation => 'convert',
            result    => '192 months'
        }
    ),
    '1 year in months' => test_zci(
        '1 year = 12 months',
        structured_answer => {
            input     => ['1 year'],
            operation => 'convert',
            result    => '12 months'
        }
    ),
    '360 degrees in revolutions' => test_zci(
        '360 degrees = 1 revolution',
        structured_answer => {
            input     => ['360 degrees'],
            operation => 'convert',
            result    => '1 revolution'
        }
    ),
    '1 degree fahrenheit to celsius' => test_zci(
        '1 degree fahrenheit = -17.222 degrees celsius',
        structured_answer => {
            input => ['1 degree fahrenheit'],
            operation => 'convert',
            result => '-17.222 degrees celsius'
        }
    ),
    '12 degrees Celsius to Fahrenheit' => test_zci(
        '12 degrees celsius = 53.600 degrees fahrenheit',
        structured_answer => {
            input     => ['12 degrees celsius'],
            operation => 'convert',
            result    => "53.600 degrees fahrenheit"
        }
    ),
    '1 degrees Fahrenheit to celsius' => test_zci(
        '1 degree fahrenheit = -17.222 degrees celsius',
        structured_answer => {
            input     => ['1 degree fahrenheit'],
            operation => 'convert',
            result    => "-17.222 degrees celsius"
        }
    ),
    '0 c in kelvin' => test_zci(
        '0 degrees celsius = 273.150 kelvin',
        structured_answer => {
            input     => ['0 degrees celsius'],
            operation => 'convert',
            result    => '273.150 kelvin'
        }
    ),
    '234 f to c' => test_zci(
        '234 degrees fahrenheit = 112.222 degrees celsius',
        structured_answer => {
            input     => ['234 degrees fahrenheit'],
            operation => 'convert',
            result    => "112.222 degrees celsius"
        }
    ),
    '234 f to kelvin' => test_zci(
        '234 degrees fahrenheit = 385.372 kelvin',
        structured_answer => {
            input     => ['234 degrees fahrenheit'],
            operation => 'convert',
            result    => '385.372 kelvin'
        }
    ),
    'metres from 20 yards' => test_zci(
        '20 yards = 18.288 meters',
        structured_answer => {
            input     => ['20 yards'],
            operation => 'convert',
            result    => '18.288 meters'
        }
    ),
    '7 milligrams to micrograms' => test_zci(
        '7 milligrams = 7,000 micrograms',
        structured_answer => {
            input     => ['7 milligrams'],
            operation => 'convert',
            result    => '7,000 micrograms'
        }
    ),
    'inches in 5 meters' => test_zci(
        '5 meters = 196.850 inches',
        structured_answer => {
            input     => ['5 meters'],
            operation => 'convert',
            result    => '196.850 inches'
        }
    ),
    '5 inches in meters' => test_zci(
        '5 inches = 0.127 meters',
        structured_answer => {
            input     => ['5 inches'],
            operation => 'convert',
            result    => '0.127 meters'
        }
    ),
    'millilitres in a gallon' => test_zci(
        '1 us gallon = 3,785.412 millilitres',
        structured_answer => {
            input     => ['1 us gallon'],
            operation => 'convert',
            result    => '3,785.412 millilitres'
        }
    ),
    'gallons in a millilitres' => test_zci(
        '1 millilitre = 0.000264 us gallons',
        structured_answer => {
            input     => ['1 millilitre'],
            operation => 'convert',
            result    => '0.000264 us gallons'
        }
    ),
    'feet in an inches' => test_zci(
        '1 inch = 0.083 feet',
        structured_answer => {
            input     => ['1 inch'],
            operation => 'convert',
            result    => '0.083 feet'
        }
    ),
    'ml in gallons' => test_zci(
        '1 millilitre = 0.000264 us gallons',
        structured_answer => {
            input     => ['1 millilitre'],
            operation => 'convert',
            result    => '0.000264 us gallons'
        }
    ),
    'ml in gallon' => test_zci(
        '1 us gallon = 3,785.412 millilitres',
        structured_answer => {
            input     => ['1 us gallon'],
            operation => 'convert',
            result    => '3,785.412 millilitres'
        }
    ),
    '32 ml to oz' => test_zci(
        '32 millilitres = 1.082 us fluid ounces',
        structured_answer => {
            input     => ['32 millilitres'],
            operation => 'convert',
            result    => '1.082 us fluid ounces'
        }
    ),
    '100 oz to ml' => test_zci(
        '100 us fluid ounces = 2,957.353 millilitres',
        structured_answer => {
            input     => ['100 us fluid ounces'],
            operation => 'convert',
            result    => '2,957.353 millilitres'
        }
    ),
    '100 ml to oz' => test_zci(
        '100 millilitres = 3.381 us fluid ounces',
        structured_answer => {
            input     => ['100 millilitres'],
            operation => 'convert',
            result    => '3.381 us fluid ounces'
        }
    ),
    '75 ml to ounces' => test_zci(
        '75 millilitres = 2.536 us fluid ounces',
        structured_answer => {
            input     => ['75 millilitres'],
            operation => 'convert',
            result    => '2.536 us fluid ounces'
        }
    ),
    'mm in inches' => test_zci(
        '1 millimeter = 0.039 inches',
        structured_answer => {
            input     => ['1 millimeter'],
            operation => 'convert',
            result    => '0.039 inches'
        }
    ),
    'mm in inch' => test_zci(
        '1 inch = 25.400 millimeters',
        structured_answer => {
            input     => ['1 inch'],
            operation => 'convert',
            result    => '25.400 millimeters'
        }
    ),
    'how many fl oz in a cup' => test_zci (
        '1 us cup = 8 us fluid ounces',
        structured_answer => {
            input => ['1 us cup'],
            operation => 'convert',
            result => '8 us fluid ounces'
        }
    ),
    '4 cups in quarts' => test_zci(
        '4 us cups = 1 quart',
        structured_answer => {
            input => ['4 us cups'],
            operation => 'convert',
            result => '1 quart'
        }
    ),
    'how many ounces in a cup' => test_zci(
        '1 us cup = 8 us fluid ounces',
        structured_answer => {
            input => ['1 us cup'],
            operation => 'convert',
            result => '8 us fluid ounces'
        }
    ),
    # Unusual number formats
    '3e60 degrees in revolutions' => test_zci(
        '3 * 10^60 degrees = 8.33 * 10^57 revolutions',
        structured_answer => {
            input     => ['3 * 10<sup>60</sup> degrees'],
            operation => 'convert',
            result    => '8.33 * 10<sup>57</sup> revolutions'
        }
    ),
    '4,1E5 newtons to pounds force' => test_zci(
        '4,1 * 10^5 newtons = 92.171,667 pounds force',
        structured_answer => {
            input     => ['4,1 * 10<sup>5</sup> newtons'],
            operation => 'convert',
            result    => '92.171,667 pounds force'
        }
    ),
    '4E5 newtons to pounds force' => test_zci(
        '4 * 10^5 newtons = 89,923.577 pounds force',
        structured_answer => {
            input     => ['4 * 10<sup>5</sup> newtons'],
            operation => 'convert',
            result    => '89,923.577 pounds force'
        }
    ),
    '5,0 GB to megabyte' => test_zci(
        '5,0 gigabytes = 5.000 megabytes',
        structured_answer => {
            input     => ['5,0 gigabytes'],
            operation => 'convert',
            result    => '5.000 megabytes'
        }
    ),
    '3.5e-2 miles to inches' => test_zci(
        '3.5 * 10^-2 miles = 2,217.600 inches',
        structured_answer => {
            input     => ['3.5 * 10<sup>-2</sup> miles'],
            operation => 'convert',
            result    => '2,217.600 inches'
        }
    ),
    # Areas and volumes
    '100 square metres in hectares' => test_zci(
        '100 square meters = 0.010 hectares',
        structured_answer => {
            input     => ['100 square meters'],
            operation => 'convert',
            result    => '0.010 hectares'
        }
    ),
    '0.0001 hectares in square metres' => test_zci(
        '0.0001 hectares = 1 square meter',
        structured_answer => {
            input     => ['0.0001 hectares'],
            operation => 'convert',
            result    => '1 square meter'
        }
    ),
    '5 sq mi in square meters' => test_zci(
        '5 square miles = 1.29 * 10^7 square meters',
        structured_answer => {
            input     => ['5 square miles'],
            operation => 'convert',
            result    => '1.29 * 10<sup>7</sup> square meters'
        }
    ),
    '1 imperial gallon in litres' => test_zci(
        '1 imperial gallon = 4.546 litres',
        structured_answer => {
            input     => ['1 imperial gallon'],
            operation => 'convert',
            result    => '4.546 litres'
        }
    ),
    '0.001 litres in millilitres' => test_zci(
        '0.001 litres = 1 millilitre',
        structured_answer => {
            input     => ['0.001 litres'],
            operation => 'convert',
            result    => '1 millilitre'
        }
    ),
    '1 hectare in square metres' => test_zci(
        '1 hectare = 10,000 square meters',
        structured_answer => {
            input     => ['1 hectare'],
            operation => 'convert',
            result    => '10,000 square meters'
        }
    ),
    '1 acre in square kilometers' => test_zci(
        '1 acre = 0.004 square kilometers',
        structured_answer => {
            input     => ['1 acre'],
            operation => 'convert',
            result    => '0.004 square kilometers'
        }
    ),
    '1 acres in square meters' => test_zci(
        '1 acre = 4,046.873 square meters',
        structured_answer => {
            input     => ['1 acre'],
            operation => 'convert',
            result    => '4,046.873 square meters'
        }
    ),
    # Question-style
    'what is 1 inch in cm' => test_zci(
        '1 inch = 2.540 centimeters',
        structured_answer => {
            input     => ['1 inch'],
            operation => 'convert',
            result    => '2.540 centimeters'
        }
    ),
    'what are 10 yards in metres' => test_zci(
        '10 yards = 9.144 meters',
        structured_answer => {
            input     => ['10 yards'],
            operation => 'convert',
            result    => '9.144 meters'
        }
    ),
    'how long is 42 days in mins' => test_zci(
        '42 days = 60,480 minutes',
        structured_answer => {
            input     => ['42 days'],
            operation => 'convert',
            result    => '60,480 minutes'
        }
    ),
    'how much is 40 kelvin in celsius' => test_zci(
        '40 kelvin = -233.150 degrees celsius',
        structured_answer => {
            input     => ['40 kelvin'],
            operation => 'convert',
            result    => '-233.150 degrees celsius'
        }
    ),
    'how much is 40 kelvin in celsius?' => test_zci(
        '40 kelvin = -233.150 degrees celsius',
        structured_answer => {
            input     => ['40 kelvin'],
            operation => 'convert',
            result    => "-233.150 degrees celsius"
        }
    ),
    'how many metres in 10 of yard?' => test_zci(
        '10 yards = 9.144 meters',
        structured_answer => {
            input     => ['10 yards'],
            operation => 'convert',
            result    => '9.144 meters'
        }
    ),
    'how many metres in 10 yards?' => test_zci(
        '10 yards = 9.144 meters',
        structured_answer => {
            input     => ['10 yards'],
            operation => 'convert',
            result    => '9.144 meters'
        }
    ),
    'how many pounds in 1 kilogram' => test_zci(
        '1 kilogram = 2.205 pounds',
        structured_answer => {
            input     => ['1 kilogram'],
            operation => 'convert',
            result    => '2.205 pounds'
        }
    ),
    'how many pounds in kilogram' => test_zci(
        '1 kilogram = 2.205 pounds',
        structured_answer => {
            input     => ['1 kilogram'],
            operation => 'convert',
            result    => '2.205 pounds'
        }
    ),
    'how many pounds in kilograms?' => test_zci(
        '1 pound = 0.454 kilograms',
        structured_answer => {
            input     => ['1 pound'],
            operation => 'convert',
            result    => '0.454 kilograms'
        }
    ),
    'how many cm in a metre?' => test_zci(
        '1 meter = 100 centimeters',
        structured_answer => {
            input     => ['1 meter'],
            operation => 'convert',
            result    => '100 centimeters'
        }
    ),
    'how many cm in metres?' => test_zci(
        '1 centimeter = 0.010 meters',
        structured_answer => {
            input     => ['1 centimeter'],
            operation => 'convert',
            result    => '0.010 meters'
        }
    ),
    'how many cm in an inch?' => test_zci(
        '1 inch = 2.540 centimeters',
        structured_answer => {
            input     => ['1 inch'],
            operation => 'convert',
            result    => '2.540 centimeters'
        }
    ),
    'how much is a liter in gallons?' => test_zci(
        '1 litre = 0.264 us gallons',
        structured_answer => {
            input     => ['1 litre'],
            operation => 'convert',
            result    => '0.264 us gallons'
        }
    ),
    'how much is a gallon in litres?' => test_zci(
        '1 us gallon = 3.785 litres',
        structured_answer => {
            input     => ['1 us gallon'],
            operation => 'convert',
            result    => '3.785 litres'
        }
    ),
    'how many gallons in a litre' => test_zci(
        '1 litre = 0.264 us gallons',
        structured_answer => {
            input     => ['1 litre'],
            operation => 'convert',
            result    => '0.264 us gallons'
        }
    ),
    'number of cm in 100 m' => test_zci(
        '100 meters = 10,000 centimeters',
        structured_answer => {
            input     => ['100 meters'],
            operation => 'convert',
            result    => '10,000 centimeters'
        }
    ),
    '1 acres in square kilometers' => test_zci(
        '1 acre = 0.004 square kilometers',
        structured_answer => {
            input     => ['1 acre'],
            operation => 'convert',
            result    => '0.004 square kilometers'
        }
    ),
    '1 acres in square meters' => test_zci(
        '1 acre = 4,046.873 square meters',
        structured_answer => {
            input     => ['1 acre'],
            operation => 'convert',
            result    => '4,046.873 square meters'
        }
    ),
    '-40 fahrenheit in celsius' => test_zci(
        '-40 degrees fahrenheit = -40 degrees celsius',
        structured_answer => {
            input => ['-40 degrees fahrenheit'],
            operation => 'convert',
            result => '-40 degrees celsius'
        }
    ),
    '-40 celsius in fahrenheit' => test_zci(
        '-40 degrees celsius = -40 degrees fahrenheit',
        structured_answer => {
            input => ['-40 degrees celsius'],
            operation => 'convert',
            result => '-40 degrees fahrenheit'
        }
    ),
    
    ## Full suite of tests around temperatures
    # for computational accuracy rather than
    # parsing accuracy
    '10 fahrenheit in fahrenheit' => test_zci(
        '10 degrees fahrenheit = 10 degrees fahrenheit',
        structured_answer => {
            input => ['10 degrees fahrenheit'],
            operation => 'convert',
            result => '10 degrees fahrenheit'
        }
    ),
    '10 celsius in fahrenheit' => test_zci(
        '10 degrees celsius = 50 degrees fahrenheit',
        structured_answer => {
            input => ['10 degrees celsius'],
            operation => 'convert',
            result => '50 degrees fahrenheit'
        }
    ),
    '10 kelvin in fahrenheit' => test_zci(
        '10 kelvin = -441.670 degrees fahrenheit',
        structured_answer => {
            input => ['10 kelvin'],
            operation => 'convert',
            result => '-441.670 degrees fahrenheit'
        }
    ),
    '10 rankine in fahrenheit' => test_zci(
        '10 degrees rankine = -449.670 degrees fahrenheit',
        structured_answer => {
            input => ['10 degrees rankine'],
            operation => 'convert',
            result => '-449.670 degrees fahrenheit'
        }
    ),
    '1234 fahrenheit in fahrenheit' => test_zci(
        '1,234 degrees fahrenheit = 1,234 degrees fahrenheit',
        structured_answer => {
            input => ['1,234 degrees fahrenheit'],
            operation => 'convert',
            result => '1,234 degrees fahrenheit'
        }
    ),
    '1234 celsius in fahrenheit' => test_zci(
        '1,234 degrees celsius = 2,253.200 degrees fahrenheit',
        structured_answer => {
            input => ['1,234 degrees celsius'],
            operation => 'convert',
            result => '2,253.200 degrees fahrenheit'
        }
    ),
    '1234 kelvin in fahrenheit' => test_zci(
        '1,234 kelvin = 1,761.530 degrees fahrenheit',
        structured_answer => {
            input => ['1,234 kelvin'],
            operation => 'convert',
            result => '1,761.530 degrees fahrenheit'
        }
    ),
    '1234 rankine in fahrenheit' => test_zci(
        '1,234 degrees rankine = 774.330 degrees fahrenheit',
        structured_answer => {
            input => ['1,234 degrees rankine'],
            operation => 'convert',
            result => '774.330 degrees fahrenheit'
        }
    ),
    '-87 fahrenheit in fahrenheit' => test_zci(
        '-87 degrees fahrenheit = -87 degrees fahrenheit',
        structured_answer => {
            input => ['-87 degrees fahrenheit'],
            operation => 'convert',
            result => '-87 degrees fahrenheit'
        }
    ),
    '-87 celsius in fahrenheit' => test_zci(
        '-87 degrees celsius = -124.600 degrees fahrenheit',        
        structured_answer => {
            input => ['-87 degrees celsius'],
            operation => 'convert',
            result => '-124.600 degrees fahrenheit'
        }
    ),
    '-87 kelvin in fahrenheit' => undef,
    '-87 rankine in fahrenheit' => undef,
    '-7 fahrenheit in fahrenheit' => test_zci(
        '-7 degrees fahrenheit = -7 degrees fahrenheit',
        structured_answer => {
            input => ['-7 degrees fahrenheit'],
            operation => 'convert',
            result => '-7 degrees fahrenheit'
        }
    ),
    '-7 celsius in fahrenheit' => test_zci(
        '-7 degrees celsius = 19.400 degrees fahrenheit',
        structured_answer => {
            input => ['-7 degrees celsius'],
            operation => 'convert',
            result => '19.400 degrees fahrenheit'
        }
    ),
    '-7 kelvin in fahrenheit' => undef,
    '-7 rankine in fahrenheit' => undef,
    
    '0 fahrenheit in fahrenheit' => test_zci(
        '0 degrees fahrenheit = 0 degrees fahrenheit',
        structured_answer => {
            input => ['0 degrees fahrenheit'],
            operation => 'convert',
            result => '0 degrees fahrenheit'
        }
    ),,
    '0 celsius in fahrenheit' => test_zci(
        '0 degrees celsius = 32 degrees fahrenheit',
        structured_answer => {
            input => ['0 degrees celsius'],
            operation => 'convert',
            result => '32 degrees fahrenheit'
        }
    ),
    '0 kelvin in fahrenheit' => test_zci(
        '0 kelvin = -459.670 degrees fahrenheit',
        structured_answer => {
            input => ['0 kelvin'],
            operation => 'convert',
            result => '-459.670 degrees fahrenheit'
        }
    ),
    '0 rankine in fahrenheit' => test_zci(
        '0 degrees rankine = -459.670 degrees fahrenheit',
        structured_answer => {
            input => ['0 degrees rankine'],
            operation => 'convert',
            result => '-459.670 degrees fahrenheit'
        }
    ),
    '10 fahrenheit in celsius' => test_zci(
        '10 degrees fahrenheit = -12.222 degrees celsius',
        structured_answer => {
            input => ['10 degrees fahrenheit'],
            operation => 'convert',
            result => '-12.222 degrees celsius'
        }
    ),
    '10 celsius in celsius' => test_zci(
        '10 degrees celsius = 10 degrees celsius',
        structured_answer => {
            input => ['10 degrees celsius'],
            operation => 'convert',
            result => '10 degrees celsius'
        }
    ),
    '10 kelvin in celsius' => test_zci(
        '10 kelvin = -263.150 degrees celsius',
        structured_answer => {
            input => ['10 kelvin'],
            operation => 'convert',
            result => '-263.150 degrees celsius'
        }
    ),
    '10 rankine in celsius' => test_zci(
        '10 degrees rankine = -267.594 degrees celsius',
        structured_answer => {
            input => ['10 degrees rankine'],
            operation => 'convert',
            result => '-267.594 degrees celsius'
        }
    ),
    
    '1234 fahrenheit in celsius' => test_zci(
        '1,234 degrees fahrenheit = 667.778 degrees celsius',
        structured_answer => {
            input => ['1,234 degrees fahrenheit'],
            operation => 'convert',
            result => '667.778 degrees celsius'
        }
    ),
    '1234 celsius in celsius' => test_zci(
        '1,234 degrees celsius = 1,234 degrees celsius',
        structured_answer => {
            input => ['1,234 degrees celsius'],
            operation => 'convert',
            result => '1,234 degrees celsius'
        }
    ),
    '1234 kelvin in celsius' => test_zci(
        '1,234 kelvin = 960.850 degrees celsius',
        structured_answer => {
            input => ['1,234 kelvin'],
            operation => 'convert',
            result => '960.850 degrees celsius'
        }
    ),
    '1234 rankine in celsius' => test_zci(
        '1,234 degrees rankine = 412.406 degrees celsius',
        structured_answer => {
            input => ['1,234 degrees rankine'],
            operation => 'convert',
            result => '412.406 degrees celsius'
        }
    ),
    '-87 fahrenheit in celsius' => test_zci(
        '-87 degrees fahrenheit = -66.111 degrees celsius',
        structured_answer => {
            input => ['-87 degrees fahrenheit'],
            operation => 'convert',
            result => '-66.111 degrees celsius'
        }
    ),
    '-87 celsius in celsius' => test_zci(
        '-87 degrees celsius = -87 degrees celsius',
        structured_answer => {
            input => ['-87 degrees celsius'],
            operation => 'convert',
            result => '-87 degrees celsius'
        }
    ),
    '-87 kelvin in celsius' => undef,
    '-87 rankine in celsius' => undef,
    '-7 fahrenheit in celsius' => test_zci(
        '-7 degrees fahrenheit = -21.667 degrees celsius',
        structured_answer => {
            input => ['-7 degrees fahrenheit'],
            operation => 'convert',
            result => '-21.667 degrees celsius'
        }
    ),
    '-7 celsius in celsius' => test_zci(
        '-7 degrees celsius = -7 degrees celsius',
        structured_answer => {
            input => ['-7 degrees celsius'],
            operation => 'convert',
            result => '-7 degrees celsius'
        }
    ),
    '-7 kelvin in celsius' => undef,
    '-7 rankine in celsius' => undef,
    '0 fahrenheit in celsius' => test_zci(
        '0 degrees fahrenheit = -17.778 degrees celsius',
        structured_answer => {
            input => ['0 degrees fahrenheit'],
            operation => 'convert',
            result => '-17.778 degrees celsius'
        }
    ),
    '0 celsius in celsius' => test_zci(
        '0 degrees celsius = 0 degrees celsius',
        structured_answer => {
            input => ['0 degrees celsius'],
            operation => 'convert',
            result => '0 degrees celsius'
        }
    ),,
    '0 kelvin in celsius' => test_zci(
        '0 kelvin = -273.150 degrees celsius',
        structured_answer => {
            input => ['0 kelvin'],
            operation => 'convert',
            result => '-273.150 degrees celsius'
        }
    ),
    '0 rankine in celsius' => test_zci(
        '0 degrees rankine = -273.150 degrees celsius',
        structured_answer => {
            input => ['0 degrees rankine'],
            operation => 'convert',
            result => '-273.150 degrees celsius'
        }
    ),
    '10 fahrenheit in kelvin' => test_zci(
        '10 degrees fahrenheit = 260.928 kelvin',
        structured_answer => {
            input => ['10 degrees fahrenheit'],
            operation => 'convert',
            result => '260.928 kelvin'
        }
    ),
    '10 celsius in kelvin' => test_zci(
        '10 degrees celsius = 283.150 kelvin',
        structured_answer => {
            input => ['10 degrees celsius'],
            operation => 'convert',
            result => '283.150 kelvin'
        }
    ),
    '10 kelvin in kelvin' => test_zci(
        '10 kelvin = 10 kelvin',
        structured_answer => {
            input => ['10 kelvin'],
            operation => 'convert',
            result => '10 kelvin'
        }
    ),
    '10 rankine in kelvin' => test_zci(
        '10 degrees rankine = 5.556 kelvin',
        structured_answer => {
            input => ['10 degrees rankine'],
            operation => 'convert',
            result => '5.556 kelvin'
        }
    ),
    '1234 fahrenheit in kelvin' => test_zci(
        '1,234 degrees fahrenheit = 940.928 kelvin',
        structured_answer => {
            input => ['1,234 degrees fahrenheit'],
            operation => 'convert',
            result => '940.928 kelvin'
        }
    ),
    '1234 celsius in kelvin' => test_zci(
        '1,234 degrees celsius = 1,507.150 kelvin',
        structured_answer => {
            input => ['1,234 degrees celsius'],
            operation => 'convert',
            result => '1,507.150 kelvin'
        }
    ),
    '1234 kelvin in kelvin' => test_zci(
        '1,234 kelvin = 1,234 kelvin',
        structured_answer => {
            input => ['1,234 kelvin'],
            operation => 'convert',
            result => '1,234 kelvin'
        }
    ),
    '1234 rankine in kelvin' => test_zci(
        '1,234 degrees rankine = 685.556 kelvin',
        structured_answer => {
            input => ['1,234 degrees rankine'],
            operation => 'convert',
            result => '685.556 kelvin'
        }
    ),
    '-87 fahrenheit in kelvin' => test_zci(
        '-87 degrees fahrenheit = 207.039 kelvin',
        structured_answer => {
            input => ['-87 degrees fahrenheit'],
            operation => 'convert',
            result => '207.039 kelvin'
        }
    ),
    '-87 celsius in kelvin' => test_zci(
        '-87 degrees celsius = 186.150 kelvin',
        structured_answer => {
            input => ['-87 degrees celsius'],
            operation => 'convert',
            result => '186.150 kelvin'
        }
    ),
    '-87 kelvin in kelvin' => undef,
    '-87 rankine in kelvin' => undef,
    
    '-7 fahrenheit in kelvin' => test_zci(
        '-7 degrees fahrenheit = 251.483 kelvin',
        structured_answer => {
            input => ['-7 degrees fahrenheit'],
            operation => 'convert',
            result => '251.483 kelvin'
        }
    ),
    '-7 celsius in kelvin' => test_zci(
        '-7 degrees celsius = 266.150 kelvin',
        structured_answer => {
            input => ['-7 degrees celsius'],
            operation => 'convert',
            result => '266.150 kelvin'
        }
    ),
    '-7 kelvin in kelvin' => undef,
    '-7 rankine in kelvin' => undef,
    '0 fahrenheit in kelvin' => test_zci(
        '0 degrees fahrenheit = 255.372 kelvin',
        structured_answer => {
            input => ['0 degrees fahrenheit'],
            operation => 'convert',
            result => '255.372 kelvin'
        }
    ),
    '0 celsius in kelvin' => test_zci(
        '0 degrees celsius = 273.150 kelvin',
        structured_answer => {
            input => ['0 degrees celsius'],
            operation => 'convert',
            result => '273.150 kelvin'
        }
    ),
    '0 kelvin in kelvin' => test_zci(
        '0 kelvin = 0 kelvin',
        structured_answer => {
            input => ['0 kelvin'],
            operation => 'convert',
            result => '0 kelvin'
        }
    ),,
    '0 rankine in kelvin' => test_zci(
        '0 degrees rankine = 0 kelvin',
        structured_answer => {
            input => ['0 degrees rankine'],
            operation => 'convert',
            result => '0 kelvin'
        }
    ),
    
    '10 fahrenheit in rankine' => test_zci(
        '10 degrees fahrenheit = 469.670 degrees rankine',
        structured_answer => {
            input => ['10 degrees fahrenheit'],
            operation => 'convert',
            result => '469.670 degrees rankine'
        }
    ),
    '10 celsius in rankine' => test_zci(
        '10 degrees celsius = 509.670 degrees rankine',        
        structured_answer => {
            input => ['10 degrees celsius'],
            operation => 'convert',
            result => '509.670 degrees rankine'
        }
    ),
    '10 kelvin in rankine' => test_zci(
        '10 kelvin = 18 degrees rankine',
        structured_answer => {
            input => ['10 kelvin'],
            operation => 'convert',
            result => '18 degrees rankine'
        }
    ),
    '10 rankine in rankine' => test_zci(
        '10 degrees rankine = 10 degrees rankine',
        structured_answer => {
            input => ['10 degrees rankine'],
            operation => 'convert',
            result => '10 degrees rankine'
        }
    ),
    '1234 fahrenheit in rankine' => test_zci(
        '1,234 degrees fahrenheit = 1,693.670 degrees rankine',
        structured_answer => {
            input => ['1,234 degrees fahrenheit'],
            operation => 'convert',
            result => '1,693.670 degrees rankine'
        }
    ),
    '1234 celsius in rankine' => test_zci(
        '1,234 degrees celsius = 2,712.870 degrees rankine',
        structured_answer => {
            input => ['1,234 degrees celsius'],
            operation => 'convert',
            result => '2,712.870 degrees rankine'
        }
    ),
    '1234 kelvin in rankine' => test_zci(
        '1,234 kelvin = 2,221.200 degrees rankine',
        structured_answer => {
            input => ['1,234 kelvin'],
            operation => 'convert',
            result => '2,221.200 degrees rankine'
        }
    ),
    '1234 rankine in rankine' => test_zci(
        '1,234 degrees rankine = 1,234 degrees rankine',
        structured_answer => {
            input => ['1,234 degrees rankine'],
            operation => 'convert',
            result => '1,234 degrees rankine'
        }
    ),
    '-87 fahrenheit in rankine' => test_zci(
        '-87 degrees fahrenheit = 372.670 degrees rankine',
        structured_answer => {
            input => ['-87 degrees fahrenheit'],
            operation => 'convert',
            result => '372.670 degrees rankine'
        }
    ),
    '-87 celsius in rankine' => test_zci(
        '-87 degrees celsius = 335.070 degrees rankine',
        structured_answer => {
            input => ['-87 degrees celsius'],
            operation => 'convert',
            result => '335.070 degrees rankine'
        }
    ),
    '-87 kelvin in rankine' => undef,
    '-87 rankine in rankine' => undef,
    '-7 fahrenheit in rankine' => test_zci(
        '-7 degrees fahrenheit = 452.670 degrees rankine',
        structured_answer => {
            input => ['-7 degrees fahrenheit'],
            operation => 'convert',
            result => '452.670 degrees rankine'
        }
    ),
    '-7 celsius in rankine' => test_zci(
        '-7 degrees celsius = 479.070 degrees rankine',
        structured_answer => {
            input => ['-7 degrees celsius'],
            operation => 'convert',
            result => '479.070 degrees rankine'
        }
    ),
    '-7 kelvin in rankine' => undef,
    '-7 rankine in rankine' => undef,
    '0 fahrenheit in rankine' => test_zci(
        '0 degrees fahrenheit = 459.670 degrees rankine',
        structured_answer => {
            input => ['0 degrees fahrenheit'],
            operation => 'convert',
            result => '459.670 degrees rankine'
        }
    ),
    '0 celsius in rankine' => test_zci(
        '0 degrees celsius = 491.670 degrees rankine',
        structured_answer => {
            input => ['0 degrees celsius'],
            operation => 'convert',
            result => '491.670 degrees rankine'
        }
    ),
    '0 kelvin in rankine' => test_zci(
        '0 kelvin = 0 degrees rankine',
        structured_answer => {
            input => ['0 kelvin'],
            operation => 'convert',
            result => '0 degrees rankine'
        }
    ),
    '0 rankine in rankine' => test_zci(
        '0 degrees rankine = 0 degrees rankine',
        structured_answer => {
            input => ['0 degrees rankine'],
            operation => 'convert',
            result => '0 degrees rankine'
        }
    ),,
        
    '84856 fahrenheit in fahrenheit' => test_zci(
        '84,856 degrees fahrenheit = 84,856 degrees fahrenheit',
        structured_answer => {
            input => ['84,856 degrees fahrenheit'],
            operation => 'convert',
            result => '84,856 degrees fahrenheit'
        }
    ),
    '84856 celsius in fahrenheit' => test_zci(
        '84,856 degrees celsius = 152,772.800 degrees fahrenheit',
        structured_answer => {
            input => ['84,856 degrees celsius'],
            operation => 'convert',
            result => '152,772.800 degrees fahrenheit'
        }
    ),
    '84856 kelvin in fahrenheit' => test_zci(
        '84,856 kelvin = 152,281.130 degrees fahrenheit',
        structured_answer => {
            input => ['84,856 kelvin'],
            operation => 'convert',
            result => '152,281.130 degrees fahrenheit'
        }
    ),
    '84856 rankine in fahrenheit' => test_zci(
        '84,856 degrees rankine = 84,396.330 degrees fahrenheit',
        structured_answer => {
            input => ['84,856 degrees rankine'],
            operation => 'convert',
            result => '84,396.330 degrees fahrenheit'
        }
    ),
    '84856 fahrenheit in celsius' => test_zci(
        '84,856 degrees fahrenheit = 47,124.444 degrees celsius',
        structured_answer => {
            input => ['84,856 degrees fahrenheit'],
            operation => 'convert',
            result => '47,124.444 degrees celsius'
        }
    ),
    '84856 celsius in celsius' => test_zci(
        '84,856 degrees celsius = 84,856 degrees celsius',
        structured_answer => {
            input => ['84,856 degrees celsius'],
            operation => 'convert',
            result => '84,856 degrees celsius'
        }
    ),
    '84856 kelvin in celsius' => test_zci(
        '84,856 kelvin = 84,582.850 degrees celsius',
        structured_answer => {
            input => ['84,856 kelvin'],
            operation => 'convert',
            result => '84,582.850 degrees celsius'
        }
    ),
    '84856 rankine in celsius' => test_zci(
        '84,856 degrees rankine = 46,869.072 degrees celsius',
        structured_answer => {
            input => ['84,856 degrees rankine'],
            operation => 'convert',
            result => '46,869.072 degrees celsius'
        }
    ),
    '84856 fahrenheit in kelvin' => test_zci(
        '84,856 degrees fahrenheit = 47,397.594 kelvin',
        structured_answer => {
            input => ['84,856 degrees fahrenheit'],
            operation => 'convert',
            result => '47,397.594 kelvin'
        }
    ),
    '84856 celsius in kelvin' => test_zci(
        '84,856 degrees celsius = 85,129.150 kelvin',
        structured_answer => {
            input => ['84,856 degrees celsius'],
            operation => 'convert',
            result => '85,129.150 kelvin'
        }
    ),
    '84856 kelvin in kelvin' => test_zci(
        '84,856 kelvin = 84,856 kelvin',
        structured_answer => {
            input => ['84,856 kelvin'],
            operation => 'convert',
            result => '84,856 kelvin'
        }
    ),
    '84856 rankine in kelvin' => test_zci(
        '84,856 degrees rankine = 47,142.222 kelvin',
        structured_answer => {
            input => ['84,856 degrees rankine'],
            operation => 'convert',
            result => '47,142.222 kelvin'
        }
    ),
    '84856 fahrenheit in rankine' => test_zci(
        '84,856 degrees fahrenheit = 85,315.670 degrees rankine',
        structured_answer => {
            input => ['84,856 degrees fahrenheit'],
            operation => 'convert',
            result => '85,315.670 degrees rankine'
        }
    ),
    '84856 celsius in rankine' => test_zci(
        '84,856 degrees celsius = 153,232.470 degrees rankine',
        structured_answer => {
            input => ['84,856 degrees celsius'],
            operation => 'convert',
            result => '153,232.470 degrees rankine'
        }
    ),
    '84856 kelvin in rankine' => test_zci(
        '84,856 kelvin = 152,740.800 degrees rankine',
        structured_answer => {
            input => ['84,856 kelvin'],
            operation => 'convert',
            result => '152,740.800 degrees rankine'
        }
    ),
    '84856 rankine in rankine' => test_zci(
        '84,856 degrees rankine = 84,856 degrees rankine',
        structured_answer => {
            input => ['84,856 degrees rankine'],
            operation => 'convert',
            result => '84,856 degrees rankine'
        }
    ),
    
    #Question format:
    'How to convert meters to inches' => test_zci(
        '1 meter = 39.370 inches',
        structured_answer => {
            input => ['1 meter'],
            operation => 'convert',
            result => '39.370 inches'
        }
    ),
    '250 feet to inches' => test_zci(
        '250 feet = 3,000 inches',
        structured_answer => {
            input => ['250 feet'],
            operation => 'convert',
            result => '3,000 inches'
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
