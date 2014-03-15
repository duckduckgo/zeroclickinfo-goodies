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
    'convert 1 ton to long ton'       => test_zci('1 ton is 0.893 long tons',),
    '2 tons to kg'                    => test_zci('2 tons is 1814.372 kilograms',),
    '1 ton to kilos'                  => test_zci('1 ton is 907.186 kilograms',),
    '3.9 oz in g'                     => test_zci('3.9 ounces is 110.563 grams',),
    '2 miles to km'                   => test_zci('2 miles is 3.219 kilometers',),
    'convert 5 feet to in'            => test_zci('5 feet is 60.000 inches',),
    '0.5 nautical mile to klick'      => test_zci('0.5 nautical miles is 0.926 kilometers',),
    '500 miles in metres'             => test_zci('500 miles is 804672.249 meters',),
    '25 cm in inches'                 => test_zci('25 centimeters is 9.843 inches',),
    '1760 yards to miles'             => test_zci('1760 yards is 1.000 mile',),
    '3520yards to miles'              => test_zci('3520 yards is 2.000 miles',),
    'convert 1stone to lbs'           => test_zci('1 stone is 14.000 pounds',),
    '30cm in in'                      => test_zci('30 centimeters is 11.811 inches',),
    '36 months to years'              => test_zci('36 months is 3.000 years',),
    '43200 seconds in hours'          => test_zci('43200 seconds is 12.000 hours',),
    '4 hours to minutes'              => test_zci('4 hours is 240.000 minutes',),
    'convert 5 kelvin to fahrenheit'  => test_zci('5 degrees kelvin is -450.670 degrees fahrenheit'),
    '1 bar to pascal'                 => test_zci('1 bar is 100000.000 pascals',),
    '1 kilopascal to psi'             => test_zci('1 kilopascal is 0.145 pounds per square inch',),
    '1 atm to kpa'                    => test_zci('1 atmosphere is 101.325 kilopascals',),
    '5yrds to km'                     => test_zci('5 yards is 0.005 kilometers'),
    '12" to cm'                       => test_zci('12 inches is 30.480 centimeters'),
    'convert 25 inches into feet'     => test_zci('25 inches is 2.083 feet'),
	'42 kilowatt hours in joules'     => test_zci('42 kilowatt-hours is 151200000.000 joules'),
	'2500kcal in tons of tnt'         => test_zci('2500 large calories is 0.003 tons of TNT'),
	'90 ps in watts'                  => test_zci('90 metric horsepower is 66194.888 watts'),
	'1 gigawatt in horsepower'        => test_zci('1 gigawatt is 1341022.090 horsepower'),
	'180 degrees in radians'          => test_zci('180 degrees is 3.142 radians'),
	'270 degrees in quadrants'        => test_zci('270 degrees is 3.000 quadrants'),
	'180 degrees in grads'            => test_zci('180 degrees is 200.000 gradians'),
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
    'shoot oneself in the foot'        => undef,
    'foot in both camps'              => undef,
    '1cm in inches'                   => test_zci("1 centimeter is 0.394 inches")
);

done_testing;
