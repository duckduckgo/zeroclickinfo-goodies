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
    'size of earth' => test_zci("",  html => '<div class=\"zci--planets\"><span class=\"planets--planetImage\"><img src=\"data:image/svg+xml;base64,.*\" height=\"48\" width=\"48\"/></span><span class=\"planets--info\"><span class=\"text--primary planets--planetAttribute\">3,958.8 miles</span><span class=\"text--secondary planets--planetName\">Earth, Radius</span></span></div>'),
    'bad example query' => undef
);

done_testing;
