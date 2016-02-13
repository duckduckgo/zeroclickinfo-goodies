package DDG::Goodie::IsAwesome::organiker;
# ABSTRACT: organiker's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_organiker";
zci is_cached   => 1;

triggers start => "duckduckhack organiker";

handle remainder => sub {
    return if $_;
    return "organiker is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
