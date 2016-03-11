package DDG::Goodie::WhereAmI;
# ABSTRACT: Display the user's perceived location from GeoIP

use strict;
use DDG::Goodie;

zci is_cached => 0;

triggers start => 'where am i', 'my location', 'current location', 'my current location';

handle remainder => sub {

    return if length($_) or !$loc or !$loc->latitude or !$loc->longitude;

    return "",
        structured_answer => {
            id => 'whereami',
            name => 'Answer',   
            data => {              
                lat => $loc->latitude,
                lon => $loc->longitude
            },            
            templates => {
                group => 'places'
            }
        };
};

1;
