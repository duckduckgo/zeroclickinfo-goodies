#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DDG::GoodieRole::ImageLoader;
use DDG::Test::Location;

zci answer_type => "planets";
zci is_cached   => 1;

  # Test Code # START
  my $test_location = test_location('us'); 
  my $location = $test_location->country_code;
  # Test Code # END

ddg_goodie_test(
    [qw( DDG::Goodie::Planets )],
    'size of earth' => test_zci("Earth, Radius is 3,958.8 miles",  html => qr{<div class="zci--planets"><span class="planets--planetImage"><img src=".*" height="48" width="48"/></span><span class="planets--info"><span class="text--primary planets--planetAttribute">3,958.8 miles</span><span class="text--secondary planets--planetName">Earth, Radius</span></span></div>}),

    'size of jupiter' => test_zci("Jupiter, Radius is 43,440.7 miles",  html => qr{<div class="zci--planets"><span class="planets--planetImage"><img src=".*" height="48" width="48"/></span><span class="planets--info"><span class="text--primary planets--planetAttribute">43,440.7 miles</span><span class="text--secondary planets--planetName">Jupiter, Radius</span></span></div>}),

    'volume of mars' => test_zci("Mars, Volume is 39,133,515,914 mi<sup>3</sup>",  html => qr{<div class="zci--planets"><span class="planets--planetImage"><img src=".*" height="48" width="48"/></span><span class="planets--info"><span class="text--primary planets--planetAttribute">39,133,515,914 mi<sup>3</sup></span><span class="text--secondary planets--planetName">Mars, Volume</span></span></div>}),

    'surface area of mercury' => test_zci("Mercury, Surface Area is 28,879,000 mi<sup>2</sup>",  html => qr{<div class="zci--planets"><span class="planets--planetImage"><img src=".*" height="48" width="48"/></span><span class="planets--info"><span class="text--primary planets--planetAttribute">28,879,000 mi<sup>2</sup></span><span class="text--secondary planets--planetName">Mercury, Surface Area</span></span></div>}),

    'mass of neptune' => test_zci("Neptune, Mass is 225,775,402,703,500,000,000,000,000 lbs",  html => qr{<div class="zci--planets"><span class="planets--planetImage"><img src=".*" height="48" width="48"/></span><span class="planets--info"><span class="text--primary planets--planetAttribute">225,775,402,703,500,000,000,000,000 lbs</span><span class="text--secondary planets--planetName">Neptune, Mass</span></span></div>}),

    'area of saturn' => test_zci("Saturn, Surface Area is 16,452,636,641 mi<sup>2</sup>",  html => qr{<div class="zci--planets"><span class="planets--planetImage"><img src=".*" height="48" width="48"/></span><span class="planets--info"><span class="text--primary planets--planetAttribute">16,452,636,641 mi<sup>2</sup></span><span class="text--secondary planets--planetName">Saturn, Surface Area</span></span></div>}),

    'radius of uranus' => test_zci("Uranus, Radius is 15,759.2 miles",  html => qr{<div class="zci--planets"><span class="planets--planetImage"><img src=".*" height="48" width="48"/></span><span class="planets--info"><span class="text--primary planets--planetAttribute">15,759.2 miles</span><span class="text--secondary planets--planetName">Uranus, Radius</span></span></div>}),

    'size of venus' => test_zci("Venus, Radius is 3,760.4 miles",  html => qr{<div class="zci--planets"><span class="planets--planetImage"><img src=".*" height="48" width="48"/></span><span class="planets--info"><span class="text--primary planets--planetAttribute">3,760.4 miles</span><span class="text--secondary planets--planetName">Venus, Radius</span></span></div>}),
    'bad example query' => undef
);

done_testing;
