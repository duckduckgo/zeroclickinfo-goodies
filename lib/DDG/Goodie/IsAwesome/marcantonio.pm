package DDG::Goodie::IsAwesome::marcantonio;
# ABSTRACT: marcantonio's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_marcantonio";
zci is_cached   => 1;

name "IsAwesome marcantonio";
description "My first Goodie, it lets the world know that marcantonio is awesome";
primary_example_queries "duckduckhack marcantonio";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/marcantonio.pm";
attribution github => ["https://github.com/marcantonio", "marcantonio"],
    twitter => "marcantoniosr";

triggers start => "duckduckhack marcantonio";

handle remainder => sub {
    return if $_;
    return "marcantonio is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
