package DDG::Goodie::IsAwesome::Echosa;
# ABSTRACT: Echosa's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_echosa";
zci is_cached   => 1;

triggers start => "duckduckhack echosa";

handle remainder => sub {
    return if $_;
    return "Echosa is awesome and has successfully completed the DuckDuckHack Goodie tutorial!"
};

1;
