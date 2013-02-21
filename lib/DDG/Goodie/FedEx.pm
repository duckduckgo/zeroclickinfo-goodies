package DDG::Goodie::FedEx;

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "fedex";

triggers query_nowhitespace_nodash => qr//xio;

handle query_nowhitespace_nodash => sub {

    return;
};

1;