package DDG::Goodie::IsAwesome::ilumnatr;
# ABSTRACT: ilumnatr's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_ilumnatr";
zci is_cached   => 1;

triggers start => "duckduckhack ilumnatr";

handle remainder => sub {
    return if $_;
    return "ilumnatr is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
