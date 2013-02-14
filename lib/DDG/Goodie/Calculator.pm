package DDG::Goodie::Calculator;

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "calculator";

triggers query_lc  => qr/hell o$/;

handle query_nowhitespace => sub {
    return @_;
};

1;