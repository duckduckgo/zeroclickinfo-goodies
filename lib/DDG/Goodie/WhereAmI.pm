package DDG::Goodie::WhereAmI;
# ABSTRACT: Display the user's perceived location from GeoIP

use strict;
use DDG::Goodie;

zci is_cached => 0;

triggers start => 'where am i', 'my location', 'current location', 'my current location';

handle remainder => sub {
    return if length($_) or !$loc or !$loc->city or !$loc->latitude or !$loc->longitude;

    my $answer = 'Lat: ' . $loc->latitude . ', Lon: ' . $loc->longitude
                 . ' (near ' . join(', ', $loc->city, $loc->region || $loc->country_name) . ')';
    
    return $answer,
        structured_answer => {
            id => 'whereami',
            name => 'Map',
            model => 'Place',
            view => 'Map',
            data => {
                id => 'whereami_id',
                name => 'Apparent current location',
                city => $loc->city,
                lat => $loc->latitude,
                lon => $loc->longitude
            },
            meta => {
                zoomValue => 3,
                sourceName => 'DDG GeoIP',
                sourceUrl => 'http://duckduckgo.com'
            },
            templates => {
                group => 'places'
            }
        };
};

1;