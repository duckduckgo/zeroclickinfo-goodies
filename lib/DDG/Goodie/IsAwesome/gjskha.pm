package DDG::Goodie::IsAwesome::gjskha;
# ABSTRACT: gjskha's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_gjskha";
zci is_cached   => 1;

triggers start => "duckduckhack gjskha";

handle remainder => sub {
    return if $_;
    return "gjskha is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
