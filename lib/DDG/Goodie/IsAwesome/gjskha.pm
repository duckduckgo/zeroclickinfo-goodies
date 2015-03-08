package DDG::Goodie::IsAwesome::gjskha;
# ABSTRACT: gjskha's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_gjskha";
zci is_cached   => 1;

name "IsAwesome gjskha";
description "My first Goodie, it lets the world know that gjskha is awesome";
primary_example_queries "duckduckhack gjskha";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/gjskha.pm";
attribution github => ["https://github.com/gjskha", "gjskha"];
          
triggers start => "duckduckhack gjskha";

handle remainder => sub {
    return if $_;
    return "gjskha is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
