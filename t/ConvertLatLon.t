#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'convertlatlon';
zci is_cached => 1;

sub build_test 
{
    my ($text, $input, $operation, $answer) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => "$answer",
            subtitle => "$operation: $input",
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
	[qw( DDG::Goodie::ConvertLatLon )],
    
    #Primary example
	q`71° 10' 3" in decimal` => build_test('71.1675°', "71° 10′ 3″", "Convert to decimal", "71.1675°"),

    #Secondary examples
    '71 degrees 10 minutes 3 seconds east in decimal' => build_test('71.1675° E', "71° 10′ 3″ E", "Convert to decimal", "71.1675° E"),
    q`-16º 30' 0" -68º 9' 0" as decimal` => build_test('-16.5° -68.15°', "-16° 30′, -68° 9′", "Convert to decimal", "-16.5°, -68.15°"),
    
    #Latitudes and longitudes of cities, various trigger combinations
    #Values from Wikipedia/GeoHack toolserver
    #Sydney
    'convert 33.859972º S 151.2094° E to degrees minutes seconds' => build_test('33° 51′ 36″ S 151° 12′ 34″ E', "33.859972° S, 151.2094° E", "Convert to DMS","33° 51′ 36″ S, 151° 12′ 34″ E"),
    #Moscow
    '55° 45′ 0″ 37° 37′ 0″ in decimal' => build_test('55.75° 37.616667°', "55° 45′, 37° 37′", "Convert to decimal", "55.75°, 37.616667°"),
    #Kinshasha
    'kinshasha is 4.325 degrees south 15.322222 degrees east convert to dms' => build_test('4° 19′ 30″ S 15° 19′ 20″ E', "4.325° S, 15.322222° E", "Convert to DMS", "4° 19′ 30″ S, 15° 19′ 20″ E"),
    #Copenhagen
    '55.676111° latitude' => build_test('55° 40′ 34″', "55.676111°", "Convert to DMS", "55° 40′ 34″"),

    #Make sure "plural S" works
    "68 degrees 9 minutes S in decimal form" => build_test('68.15° S', "68° 9′ S", "Convert to decimal", "68.15° S"),

    #Should not trigger for impossible latitudes and longitudes
    q`95º 4' N as decimal` => undef,
    'convert 293.11 degrees to dms' => undef,

    #Should not trigger for impossible combinations of sign and
    # cardinal direction
    q`-71º 12' 51" S as a decimal latitude` => undef,

    #Should not trigger on unrelated queries
    'convert 61.01º farenheit to celcius' => undef,
    'how many degrees in a 12-sided polygon internal angles' => undef,
    'convert 61.125 degrees to radians' => undef,
    'are there more than 100 seconds in a day' => undef,
    'convert 4 minute mile to kilometers' => undef,
    q`attack of the 50' 4" woman` => undef,
    'is 39.75 degrees a fever' => undef,
    'convert 39.75 degrees to farenheit' => undef,

    #Check for to-format name
    '16.5° S, 68.15° W dms' => build_test("16° 30′ S 68° 9′ W", "16.5° S, 68.15° W", "Convert to DMS", "16° 30′ S, 68° 9′ W"),
    '16° 30′ S, 68° 9′ W decimal' => build_test("16.5° S 68.15° W", "16° 30′ S, 68° 9′ W", "Convert to decimal", "16.5° S, 68.15° W"),
);

done_testing;
