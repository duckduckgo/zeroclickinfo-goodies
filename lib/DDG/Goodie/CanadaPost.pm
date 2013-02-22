package DDG::Goodie::CanadaPost;

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "canadapost";

triggers query_nowhitespace_nodash => qr//xi;

handle query_nowhitespace_nodash => sub {

    return;
};

1;