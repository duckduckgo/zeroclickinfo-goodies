#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DDG::GoodieRole::ImageLoader;
use DDG::Test::Location;

zci answer_type => "solarsystem";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::SolarSystem )],

    #Test Imperial

    'size earth' => test_zci("Earth, Radius is 3,958.8 miles",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">3,958.8 miles</span><span class="text--secondary objects--objectName">Earth, Radius</span></span></div>}),

    'what is the size of earth' => test_zci("Earth, Radius is 3,958.8 miles",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">3,958.8 miles</span><span class="text--secondary objects--objectName">Earth, Radius</span></span></div>}),   

    'size of jupiter' => test_zci("Jupiter, Radius is 43,440.7 miles",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">43,440.7 miles</span><span class="text--secondary objects--objectName">Jupiter, Radius</span></span></div>}),
  
    'size of object jupiter' => test_zci("Jupiter, Radius is 43,440.7 miles",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">43,440.7 miles</span><span class="text--secondary objects--objectName">Jupiter, Radius</span></span></div>}),

    'volume of mars' => test_zci("Mars, Volume is 39,133,515,914 mi<sup>3</sup>",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">39,133,515,914 mi<sup>3</sup></span><span class="text--secondary objects--objectName">Mars, Volume</span></span></div>}),

    'surface area of mercury' => test_zci("Mercury, Surface Area is 28,879,000 mi<sup>2</sup>",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">28,879,000 mi<sup>2</sup></span><span class="text--secondary objects--objectName">Mercury, Surface Area</span></span></div>}),

    'mass of neptune' => test_zci("Neptune, Mass is 225,775,402,703,500,000,000,000,000 lbs",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">225,775,402,703,500,000,000,000,000 lbs</span><span class="text--secondary objects--objectName">Neptune, Mass</span></span></div>}),

    'area of saturn' => test_zci("Saturn, Surface Area is 16,452,636,641 mi<sup>2</sup>",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="58"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">16,452,636,641 mi<sup>2</sup></span><span class="text--secondary objects--objectName">Saturn, Surface Area</span></span></div>}),

    'radius of uranus' => test_zci("Uranus, Radius is 15,759.2 miles",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">15,759.2 miles</span><span class="text--secondary objects--objectName">Uranus, Radius</span></span></div>}),

    'size of venus' => test_zci("Venus, Radius is 3,760.4 miles",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">3,760.4 miles</span><span class="text--secondary objects--objectName">Venus, Radius</span></span></div>}),

    #Test Metric

    DDG::Request->new(query_raw => "size earth", location => test_location("au")) => test_zci("Earth, Radius is 6,371.00 km",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">6,371.00 km</span><span class="text--secondary objects--objectName">Earth, Radius</span></span></div>}),

    DDG::Request->new(query_raw => "what is the size of earth", location => test_location("au")) => test_zci("Earth, Radius is 6,371.00 km",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">6,371.00 km</span><span class="text--secondary objects--objectName">Earth, Radius</span></span></div>}),

   	DDG::Request->new(query_raw => "size of jupiter", location => test_location("au")) => test_zci("Jupiter, Radius is 69,911 km",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">69,911 km</span><span class="text--secondary objects--objectName">Jupiter, Radius</span></span></div>}),

   	DDG::Request->new(query_raw => "size of object jupiter", location => test_location("au")) => test_zci("Jupiter, Radius is 69,911 km",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">69,911 km</span><span class="text--secondary objects--objectName">Jupiter, Radius</span></span></div>}),

    DDG::Request->new(query_raw => "volume of mars", location => test_location("au")) => test_zci("Mars, Volume is 163,115,609,799 km<sup>3</sup>",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">163,115,609,799 km<sup>3</sup></span><span class="text--secondary objects--objectName">Mars, Volume</span></span></div>}),

    DDG::Request->new(query_raw => "surface area of mercury", location => test_location("au")) => test_zci("Mercury, Surface Area is 74,797,000 km<sup>2</sup>",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">74,797,000 km<sup>2</sup></span><span class="text--secondary objects--objectName">Mercury, Surface Area</span></span></div>}),

    DDG::Request->new(query_raw => "mass of neptune", location => test_location("au")) => test_zci("Neptune, Mass is 102,410,000,000,000,000,000,000,000 kg",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">102,410,000,000,000,000,000,000,000 kg</span><span class="text--secondary objects--objectName">Neptune, Mass</span></span></div>}),

    DDG::Request->new(query_raw => "area of saturn", location => test_location("au")) => test_zci("Saturn, Surface Area is 42,612,133,285 km<sup>2</sup>",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="58"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">42,612,133,285 km<sup>2</sup></span><span class="text--secondary objects--objectName">Saturn, Surface Area</span></span></div>}),

    DDG::Request->new(query_raw => "radius of uranus", location => test_location("au")) => test_zci("Uranus, Radius is 25,362 km",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">25,362 km</span><span class="text--secondary objects--objectName">Uranus, Radius</span></span></div>}),

    DDG::Request->new(query_raw => "size of venus", location => test_location("au")) => test_zci("Venus, Radius is 6,051.8 km",  html => qr{<div class="zci--objects"><span class="objects--objectImage"><img src=".*" height="48" width="48"/></span><span class="objects--info"><span class="text--primary objects--objectAttribute">6,051.8 km</span><span class="text--secondary objects--objectName">Venus, Radius</span></span></div>}),

    'size of tomato' => undef,
    'volume of water' => undef,
    'mass of RMS titanic' => undef,
    'surface area of united states' => undef,
    'radius of orange' => undef
);

done_testing;
