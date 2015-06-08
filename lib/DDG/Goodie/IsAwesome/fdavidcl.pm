package DDG::Goodie::IsAwesome::fdavidcl;
# ABSTRACT: fdavidcl's First Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_fdavidcl";
zci is_cached   => 1;

name "IsAwesome fdavidcl";
description "My first Goodie, it lets the world know that fdavidcl is awesome";
primary_example_queries "duckduckhack fdavidcl";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/fdavidcl.pm";
attribution github => ["fdavidcl", "David Charte"],
            twitter => "fdavidcl";

triggers start => "duckduckhack fdavidcl";

handle remainder => sub {
    return if $_;
    return "fdavidcl is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
