package DDG::Goodie::IsAwesome::Black616Angel;
# ABSTRACT: Black616Angels first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_black616angel";
zci is_cached   => 1;

triggers start => "duckduckhack black616angel";

handle remainder => sub {
    return if $_;
    return "Black616Angel is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
