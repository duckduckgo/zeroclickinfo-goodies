package DDG::Goodie::IsAwesome::murz;
# ABSTRACT: Murz's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_murz";
zci is_cached   => 1;

name "IsAwesome murz";
description "My first Goodie, it lets the world know that murz is awesome";
primary_example_queries "duckduckhack murz";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/murz.pm";
attribution github => ["murz", "Mike Murray"];

# Triggers
triggers start => "duckduckhack murz";

# Handle statement
handle remainder => sub {
    return if $_;
    return "murz is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
