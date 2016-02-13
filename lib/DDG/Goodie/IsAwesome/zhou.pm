package DDG::Goodie::IsAwesome::zhou;
# ABSTRACT: zhou's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_zhou";
zci is_cached   => 1;

triggers start => "duckduckhack zhou";

handle remainder => sub {
    return if $_;
    return "zhou is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};


1;
