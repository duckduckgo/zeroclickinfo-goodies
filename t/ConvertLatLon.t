#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'convertlatlon';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
    DDG::Goodie::ConvertLatLon
	)],

    #Primary example
	'71° 10\' 3" in decimal' => test_zci('71.1675°', html => qr/71\.1675/),

    #Secondary examples
    '71 degrees 10 minutes 3 seconds east in decimal' => test_zci('71.1675° E', html => qr/71\.1675.+E/),
    '- 16º 30\' 0" - 68º 9\' 0" as decimal' => test_zci('−16.5° −68.15°', html => qr/&minus;16\.5.+&minus;68\.15/),

    #Latitudes and longitudes of cities, various trigger combinations
    #Values from Wikipedia/GeoHack toolserver
    #Sydney
    'convert 33.859972º S 151.2094° E to degrees minutes seconds' => test_zci('33° 51′ 36″ S 151° 12′ 34″ E', html => qr/33.+51.+36.+S.+151.+12.+34.+E/),
    #Moscow
    '55° 45′ 0″ 37° 37′ 0″ in decimal' => test_zci('55.75° 37.616667°', html => qr/55\.75.+37\.616667/),
    #Kinshasha
    'kinshasha is 4.325 degrees south 15.322222 degrees east convert to dms' => test_zci('4° 19′ 30″ S 15° 19′ 20″ E', html => qr/4.+19.+30.+S.+15.+19.+20.+E/),
    #Copenhagen
    '55.676111° latitude' => test_zci('55° 40′ 34″', html => qr/55.+40.+34/),

    #Make sure "plural S" works
    "68 degrees 9 minutes S in decimal form" => test_zci('68.15° S', html => qr/68\.15.+S/),

    #Should not trigger for impossible latitudes and longitudes
    '95º 4\' N as decimal' => undef,
    'convert 293.11 degrees to dms' => undef,
    
    #Should not trigger for impossible combinations of sign and
    # cardinal direction
    '-71º 12\' 51" S as a decimal latitude' => undef,

    #Should not trigger on unrelated queries
    'convert 61.01º farenheit to celcius' => undef,
    'how many degrees in a 12-sided polygon internal angles' => undef,
    'convert 61.125 degrees to radians' => undef,
    'are there more than 100 seconds in a day' => undef,
    'convert 4 minute mile to kilometers' => undef,
    'attack of the 50\' 4" woman' => undef,
    'is 39.75 degrees a fever' => undef,
    'convert 39.75 degrees to farenheit' => undef,

    #Check for css
    '71° 10\' 3" in decimal' => test_zci(qr/./, html => qr/css/),

    #Check for to-format name
    '16.5° S, 68.15° W dms' => test_zci(qr/./, html => qr/DMS/),
    '16° 30′ S, 68° 9′ W decimal' => test_zci(qr/./, html => qr/decimal/),
);

done_testing;

