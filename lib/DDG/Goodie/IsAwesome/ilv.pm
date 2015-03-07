package DDG::Goodie::IsAwesome::ilv;
# ABSTRACT: ilv's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_ilv";
zci is_cached   => 1;

name "IsAwesome ilv";
description "My first Goodie, it lets the world know that ilv is awesome";
primary_example_queries "duckduckhack ilv";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/ilv.pm";
attribution github => ["https://github.com/ilv", "ilv"];

triggers start => "duckduckhack ilv";

handle remainder => sub {
    return if $_;
    return "ilv is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
