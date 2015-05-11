package DDG::Goodie::IsAwesome::v0tti;
# ABSTRACT: My first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_v0tti";
zci is_cached   => 1;

name "IsAwesome v0tti";
description "My first Goodie, it lets the world know that v0tti is awesome";
primary_example_queries "duckduckhack v0tti";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/v0tti.pm";
attribution github => ["https://github.com/v0tti", "v0tti"],
            twitter => "v0tti";
            
triggers start => "duckduckhack v0tti";

handle remainder => sub {
    return if $_;
    return "v0tti is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
