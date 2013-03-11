#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'areacode';
zci is_cached => 1;

ddg_goodie_test(
        [qw( DDG::Goodie::AreaCode )],
        'area code 602' => test_zci(
            "602 is an area code in Arizona",
            heading => 'Area Codes (Arizona)',
            html => qq(602 is an area code in Arizona - <a href="http://www.nanpa.com/area_code_maps/display.html?az">Map</a>)
        ),
        'areacode 501' => test_zci(
            "501 is an area code in Arkansas",
            heading => 'Area Codes (Arkansas)',
            html => qq(501 is an area code in Arkansas - <a href="http://www.nanpa.com/area_code_maps/display.html?ar">Map</a>)
        ),
);

done_testing;

