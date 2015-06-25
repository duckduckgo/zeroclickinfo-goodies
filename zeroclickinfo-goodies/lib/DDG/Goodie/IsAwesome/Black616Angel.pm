package DDG::Goodie::IsAwesome::Black616Angel;
# ABSTRACT: Black616Angels first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_black616angel";
zci is_cached   => 1;

name "IsAwesome Black616Angel";
description "My first Goodie, it lets the world know that Black616Angel awesome";
primary_example_queries "duckduckhack Black616Angel";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/Black616Angel.pm";
attribution github => ["https://github.com/Black616Angel", "Black616Angel"],
           ;

triggers start => "duckduckhack black616angel";

handle remainder => sub {
    return if $_;
    return "Black616Angel is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
