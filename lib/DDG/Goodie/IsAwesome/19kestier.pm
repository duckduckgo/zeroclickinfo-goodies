package DDG::Goodie::IsAwesome::19kestier;
# ABSTRACT: 19kestier's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_19kestier";
zci is_cached   => 1;

triggers start => "duckduckhack 19kestier";

handle remainder => sub {
    return if $_;
    return "19kestier is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
