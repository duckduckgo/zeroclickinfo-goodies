package DDG::Goodie::HKDK;

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "hkdk";

triggers query_nowhitespace_nodash => qr//xio;

handle query_nowhitespace_nodash => sub {

    return;
};

1;