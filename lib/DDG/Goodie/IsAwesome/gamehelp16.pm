package DDG::Goodie::IsAwesome::gamehelp16;
# ABSTRACT: gamehelp16's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_gamehelp16";
zci is_cached   => 1;

triggers start => "duckduckhack gamehelp16";

handle remainder => sub {
    return if $_;
    return "gamehelp16 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
