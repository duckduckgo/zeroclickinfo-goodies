package DDG::Goodie::LaserShip;
# ABSTRACT: Track a package through Lasership

use strict;
use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "lasership";

triggers query_nowhitespace_nodash => qr/(^l[a-z]\d{8}$)/i;

handle query_nowhitespace_nodash => sub {
    return $1, heading => "Lasership Shipment Tracking", html => qq(Track this shipment at <a href="http://lasership.com/track/$1">Lasership</a>.) if $1;
    return;
};

1;
