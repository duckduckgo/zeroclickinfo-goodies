package DDG::Goodie::WhereAmI;
# ABSTRACT: Display the user's perceived location from GeoIP

use strict;
use DDG::Goodie;

zci is_cached => 0;

triggers start => 'where am i', 'my location', 'current location', 'my current location';

handle remainder => sub {
    return if length($_) or !$loc or !$loc->city;

    my $answer = 'Lat: ' . $loc->latitude . ', Lon: ' . $loc->longitude
                 . ' (near ' . join(', ', $loc->city, $loc->region || $loc->country_name) . ')';

    return $answer,
      structured_answer => {
        input     => [],
        operation => 'Apparent current location',
        result    => $answer
      };
};

1;
