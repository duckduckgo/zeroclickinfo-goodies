package DDG::Goodie::IsAwesome::francisbrito;
# ABSTRACT: francisbrito's first goodie.

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_francisbrito";
zci is_cached   => 1;

name "IsAwesome francisbrito";
description "My first Goodie, it lets the world know that francisbrito is awesome";
primary_example_queries "duckduckhack francisbrito";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/francisbrito.pm";
attribution github => ["https://github.com/francisbrito", "francisbrito"],
            twitter => "frxbr";

triggers start => "duckduckhack francisbrito";

handle remainder => sub {
    return if $_;
    return "francisbrito is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
