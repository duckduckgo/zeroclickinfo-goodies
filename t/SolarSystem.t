#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use DDG::Test::Location;
use utf8;

zci answer_type => "solarsystem";
zci is_cached   => 1;

#Structured answer template data
my $templateData = {
            data => ignore(),
            meta => {
                sourceUrl => "https://solarsystem.nasa.gov/planets/index.cfm",
                sourceName => "NASA"
            },
            templates => {
                group => 'base',
                detail_mobile => 'DDH.solar_system.mobile',
                options => {
                    content => 'DDH.solar_system.content',
                }
            }
        };

ddg_goodie_test(
    [qw( DDG::Goodie::SolarSystem)],

    # Metric - using search trigger

    # Unit - km, kg
    "size earth km" => test_zci("Earth - Radius is 6,371 km", structured_answer => $templateData),
    "size earth in km" => test_zci("Earth - Radius is 6,371 km", structured_answer => $templateData),
    'volume of mars km3' => test_zci("Mars - Volume is 163,115,609,799 km³",  structured_answer => $templateData),
    'volume of mars km' => test_zci("Mars - Volume is 163,115,609,799 km³",  structured_answer => $templateData),
    'area of saturn km2' => test_zci("Saturn - Surface Area is 42,612,133,285 km²",  structured_answer => $templateData),
    'mass of neptune kg' => test_zci("Neptune - Mass is 1.024 × 10²⁶ kg",  structured_answer => $templateData),

    # Unit type - metric
    "size earth metric" => test_zci("Earth - Radius is 6,371 km", structured_answer => $templateData),
    "size earth in metric" => test_zci("Earth - Radius is 6,371 km", structured_answer => $templateData),
    'volume of mars metric' => test_zci("Mars - Volume is 163,115,609,799 km³",  structured_answer => $templateData),

    # Imperial - using search trigger

    # Unit - mi, lbs
    "size earth mi" => test_zci("Earth - Radius is 3,958.8 mi", structured_answer => $templateData),
    "size earth in mi" => test_zci("Earth - Radius is 3,958.8 mi", structured_answer => $templateData),
    'volume of mars mi3' => test_zci("Mars - Volume is 39,133,515,914 mi³",  structured_answer => $templateData),
    'volume of mars mi' => test_zci("Mars - Volume is 39,133,515,914 mi³",  structured_answer => $templateData),
    'area of saturn mi' => test_zci("Saturn - Surface Area is 16,452,636,641 mi²",  structured_answer => $templateData),
    'mass of neptune lbs' => test_zci("Neptune - Mass is 2.258 × 10²⁶ lbs",  structured_answer => $templateData),
    
    # Unit type - imperial
    "size earth imperial" => test_zci("Earth - Radius is 3,958.8 mi", structured_answer => $templateData),
    "size earth in imperial" => test_zci("Earth - Radius is 3,958.8 mi", structured_answer => $templateData),
    'volume of mars imperial' => test_zci("Mars - Volume is 39,133,515,914 mi³",  structured_answer => $templateData),

    # Imperial

    "size earth" => test_zci("Earth - Radius is 3,958.8 mi", structured_answer => $templateData),
    "what is the size of earth" => test_zci( "Earth - Radius is 3,958.8 mi", structured_answer => $templateData),
    'size of jupiter' => test_zci("Jupiter - Radius is 43,440.7 mi",  structured_answer => $templateData),
    'size of object jupiter' => test_zci("Jupiter - Radius is 43,440.7 mi",  structured_answer => $templateData),
    'volume of mars' => test_zci("Mars - Volume is 39,133,515,914 mi³",  structured_answer => $templateData),
    'surface area of mercury' => test_zci("Mercury - Surface Area is 28,879,000 mi²",  structured_answer => $templateData),
    'mass of neptune' => test_zci("Neptune - Mass is 2.258 × 10²⁶ lbs",  structured_answer => $templateData),
    'area of saturn' => test_zci("Saturn - Surface Area is 16,452,636,641 mi²",  structured_answer => $templateData),
    'radius of uranus' => test_zci("Uranus - Radius is 15,759.2 mi",  structured_answer => $templateData),
    'size of venus' => test_zci("Venus - Radius is 3,760.4 mi",  structured_answer => $templateData),
    'size of pluto' => test_zci("Pluto - Radius is 715.2 mi",  structured_answer => $templateData),
    'size of moon' => test_zci("Moon - Radius is 1,079.6 mi",  structured_answer => $templateData),    



    # Metric - using location (AU)

    DDG::Request->new(query_raw => "size earth", location => test_location("au")) => test_zci("Earth - Radius is 6,371 km",  structured_answer => $templateData),

    DDG::Request->new(query_raw => "what is the size of earth", location => test_location("au")) => test_zci("Earth - Radius is 6,371 km",  structured_answer => $templateData),

    DDG::Request->new(query_raw => "size of jupiter", location => test_location("au")) => test_zci("Jupiter - Radius is 69,911 km",  structured_answer => $templateData),

    DDG::Request->new(query_raw => "size of object jupiter", location => test_location("au")) => test_zci("Jupiter - Radius is 69,911 km",  structured_answer => $templateData),

    DDG::Request->new(query_raw => "volume of mars", location => test_location("au")) => test_zci("Mars - Volume is 163,115,609,799 km³",  structured_answer => $templateData),

    DDG::Request->new(query_raw => "surface area of mercury", location => test_location("au")) => test_zci("Mercury - Surface Area is 74,797,000 km²",  structured_answer => $templateData),

    DDG::Request->new(query_raw => "mass of neptune", location => test_location("au")) => test_zci("Neptune - Mass is 1.024 × 10²⁶ kg",  structured_answer => $templateData),

    DDG::Request->new(query_raw => "area of saturn", location => test_location("au")) => test_zci("Saturn - Surface Area is 42,612,133,285 km²",  structured_answer => $templateData),

    DDG::Request->new(query_raw => "radius of uranus", location => test_location("au")) => test_zci("Uranus - Radius is 25,362 km",  structured_answer => $templateData),

    DDG::Request->new(query_raw => "size of venus", location => test_location("au")) => test_zci("Venus - Radius is 6,051.8 km",  structured_answer => $templateData),

    DDG::Request->new(query_raw => "size of pluto", location => test_location("au")) => test_zci("Pluto - Radius is 1,151 km",  structured_answer => $templateData),

    DDG::Request->new(query_raw => "size of moon", location => test_location("au")) => test_zci("Moon - Radius is 1,737.5 km",  structured_answer => $templateData),

    # Do not trigger

    'size of tomato' => undef,
    'volume of water' => undef,
    'mass of RMS titanic' => undef,
    'surface area of united states' => undef,
    'radius of orange' => undef
);

done_testing;
