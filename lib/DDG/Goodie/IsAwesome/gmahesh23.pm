package DDG::Goodie::IsAwesome::gmahesh23;
# ABSTRACT: gmahesh23's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_gmahesh23";
zci is_cached   => 1;

triggers any => "duckduckhack gmahesh23";

handle remainder => sub {
    return if $_;
    return "gmahesh23 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
