package DDG::Goodie::IsAwesome::uniphil;
# ABSTRACT: uniphil's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_uniphil";
zci is_cached   => 1;

name "IsAwesome uniphil";
description "My first Goodie, it lets the world know uniphil is awesome";
primary_example_queries "duckduckhack uniphil";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/uniphil.pm";
attribution github => ["https://github.com/uniphil", "uniphil"],
            twitter => "unicyclephil";

triggers start => "duckduckhack uniphil";

handle remainder => sub {
    return if $_;
    return "uniphil is awesome and has successfully completed the DuckDuckHack Goodie tutorial!"
};

1;
