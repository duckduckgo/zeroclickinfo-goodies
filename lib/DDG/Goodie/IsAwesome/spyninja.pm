package DDG::Goodie::IsAwesome::spyninja;
# ABSTRACT: spyninja's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_spyninja";
zci is_cached   => 1;

triggers start => "duckduckhack spyninja";

handle remainder => sub {
    return if $_;
    return "spyninja is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
