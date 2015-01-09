package DDG::Goodie::LaserShip;
# ABSTRACT: Track a package through Lasership

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "lasership";

primary_example_queries 'LL12345678';
description 'Track a package from Lasership';
name 'Lasership';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/LaserShip.pm';
category 'ids';
topics 'special_interest';
attribution github => [ 'https://github.com/duckduckgo', 'duckduckgo'];

triggers query_nowhitespace_nodash => qr/(l[a-z]\d{8})/i;

handle query_nowhitespace_nodash => sub {
    return $1, heading => "Lasership Shipment Tracking", html => qq(Track this shipment at <a href="http://lasership.com/track/$1">Lasership</a>.) if $1;
    return;
};

1;
