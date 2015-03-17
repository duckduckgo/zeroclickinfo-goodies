package DDG::Goodie::IsAwesome::fish9;
# ABSTRACT: fish9's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_fish9";
zci is_cached   => 1;

name "IsAwesome fish9";
description "My first Goodie, it lets the world know that fish9 is awesome";
primary_example_queries "duckduckhack fish9";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/fish9.pm";
attribution github => ["https://github.com/fish9", "fish9"];

triggers start => "duckduckhack fish9";

handle remainder => sub {
    return if $_;
    return "fish9 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
