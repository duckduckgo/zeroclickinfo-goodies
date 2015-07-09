package DDG::Goodie::IsAwesome::rramyr;
# ABSTRACT: GitHubrramyr's first Goodie		

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_rramyr";
zci is_cached   => 1;

name "IsAwesome rramyr";
description "My first Goodie, it lets the world know that rramyr is awesome";
primary_example_queries "duckduckhack rramyr";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/rramyr.pm";
attribution github => ["https://github.com/rramyr", "rramyr"];
            
           
triggers any => "duckduckhack rramyr";

handle remainder => sub {
    return if $_;
    return "rramyr is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
