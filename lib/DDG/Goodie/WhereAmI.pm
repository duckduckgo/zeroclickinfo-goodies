package DDG::Goodie::WhereAmI;
# ABSTRACT: Display the user's perceived location from GeoIP

use strict;
use DDG::Goodie;

zci is_cached => 0;
zci answer_type => 'where_am_i';

triggers start => 'where am i', 'my location', 'current location', 'my current location';

handle remainder => sub {

    return if length($_) or !$loc or !$loc->latitude or !$loc->longitude;
    
    my $display = join(', ', $loc->city, $loc->region, $loc->country_name);

    return "",
        structured_answer => {
            id => 'where_am_i',
            name => 'Answer',   
            data => {              
                lat => $loc->latitude,
                lon => $loc->longitude,
                display => $display
            },            
            templates => {
                group => 'places'
            }
        };
};

1;
