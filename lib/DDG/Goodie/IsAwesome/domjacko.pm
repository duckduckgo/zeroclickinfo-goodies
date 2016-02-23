package DDG::Goodie::IsAwesome::domjacko;
# ABSTRACT: domjacko's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_domjacko";
zci is_cached   => 1;

triggers start => "duckduckhack domjacko";

handle remainder => sub {
    return if $_;
    return "domjacko is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
