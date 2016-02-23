package DDG::Goodie::IsAwesome::mcavallaro;
# ABSTRACT: mcavallaro's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_mcavallaro";
zci is_cached   => 1;

triggers start => "duckduckhack mcavallaro";

handle remainder => sub {
    return if $_;
    return "mcavallaro is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
