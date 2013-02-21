package DDG::Goodie::USPS;

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "usps";

triggers query_nowhitespace_nodash => qr//xi;

handle query_nowhitespace_nodash => sub {
};

1;