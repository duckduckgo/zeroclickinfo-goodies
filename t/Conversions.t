#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'conversions';

ddg_goodie_test(
    ['DDG::Goodie::Conversions'],    
    'convert 5 oz to g'               => test_zci('5 ounces is 141.747 grams',),
    'convert 1 ton to long ton'       => test_zci('1 ton is 0.893 long tons',),
    'convert 158 ounce to lbm'        => test_zci('158 ounces is 9.875 pounds',),
    'convert 0.111 stone to pound'    => test_zci('0.111 stone is 1.554 pounds',),
    '3 kilogramme to pound'           => test_zci('3 kilograms is 6.614 pounds',),
    '1.3 tonnes to ton'               => test_zci('1.3 metric tons is 1.433 tons',),
    '2 tons to kg'                    => test_zci('2 tons is 1.81e+03 kilograms',),
    '1 ton to kilos'                  => test_zci('1 ton is 907.186 kilograms',),
    '3.9 oz in g'                     => test_zci('3.9 ounces is 110.563 grams',),
    '2 miles to km'                   => test_zci('2 miles is 3.219 kilometers',),
    'convert 5 feet to in'            => test_zci('5 feet is 60 inches',),
    '0.5 nautical mile to klick'      => test_zci('0.5 nautical miles is 0.926 kilometers',),
    '500 miles in metres'             => test_zci('500 miles is 8.05e+05 meters',),
    '25 cm in inches'                 => test_zci('25 centimeters is 9.843 inches',),
    '1760 yards to miles'             => test_zci('1760 yards is 1 mile',),
    '3520yards to miles'              => test_zci('3520 yards is 2 miles',),
    'convert 1stone to lbs'           => test_zci('1 stone is 14 pounds',),
    '30cm in in'                      => test_zci('30 centimeters is 11.811 inches',),
    '36 months to years'              => test_zci('36 months is 3 years',),
    '43200 seconds in hours'          => test_zci('43200 seconds is 12 hours',),
    '4 hours to minutes'              => test_zci('4 hours is 240 minutes',),
    'convert 5 kelvin to fahrenheit'  => test_zci('5 degrees kelvin is -450.670 degrees fahrenheit'),
    '1 bar to pascal'                 => test_zci('1 bar is 100000 pascals',),
    '1 kilopascal to psi'             => test_zci('1 kilopascal is 0.145 pounds per square inch',),
    '1 atm to kpa'                    => test_zci('1 atmosphere is 101.325 kilopascals',),
    '5yrds to km'                     => test_zci('5 yards is 0.005 kilometers'),
    '12" to cm'                       => test_zci('12 inches is 30.480 centimeters'),
    'convert 25 inches into feet'     => test_zci('25 inches is 2.083 feet'),
    '42 kilowatt hours in joules'     => test_zci('42 kilowatt-hours is 1.51e+08 joules'),
    '2500kcal in tons of tnt'         => test_zci('2500 large calories is 0.003 tons of TNT'),
    '90 ps in watts'                  => test_zci('90 metric horsepower is 6.62e+04 watts'),
    '1 gigawatt in horsepower'        => test_zci('1 gigawatt is 1.34e+06 horsepower'),
    '180 degrees in radians'          => test_zci('180 degrees is 3.142 radians'),
    '270 degrees in quadrants'        => test_zci('270 degrees is 3 quadrants'),
    '180 degrees in grads'            => test_zci('180 degrees is 200 gradians'),
    '45 newtons to pounds force'      => test_zci('45 newtons is 10.116 pounds force'),
    '8 poundal to newtons'            => test_zci('8 poundals is 1.106 newtons'),
    'convert 5 f to celsius'          => test_zci('5 degrees fahrenheit is -14.985 degrees celsius'),
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
    '10 mg to tons'                   => test_zci('10 milligrams is 1.1e-08 tons'),
    '10000 minutes in microseconds'   => test_zci('10000 minutes is 6e+11 microseconds'),
    'convert 5 bytes to bit'          => test_zci('5 bytes is 40 bits'),
    '5 GB to megabyte'                => test_zci('5 gigabytes is 5000 megabytes'),
    '0.013 mb in bits'                => test_zci('0.013 megabytes is 104000 bits'),
    '1 exabyte to pib'                => test_zci('1 exabyte is 888.178 pebibytes'),
    'convert 1 yb to yib'             => test_zci('1 yottabyte is 0.827 yobibytes'),
    '16 years in months'              => test_zci('16 years is 192 months'),
    '1 year in months'                => test_zci('1 year is 12 months')
);

done_testing;
