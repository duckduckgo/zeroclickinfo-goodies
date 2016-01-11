package DDG::Goodie::IsAwesome::jimbrighter;
# ABSTRACT: first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_jimbrighter";
zci is_cached   => 1;

triggers start => "duckduckhack jimbrighter";

handle remainder => sub {
    return if $_;
    return "jim-brighter is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";

};

1;
