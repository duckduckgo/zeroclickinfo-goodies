package DDG::Goodie::IsAwesome::fabrgu;
# ABSTRACT: fabrgu's first attempt at making a goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_fabrgu";
zci is_cached   => 1;

name "IsAwesome fabrgu";
description "My first Goodie, it lets the world know that fabrgu is awesome";
primary_example_queries "duckduckhack fabrgu";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/fabrgu.pm";
attribution github => ["https://github.com/fabrgu", "fabrgu"];

triggers start => "duckduckhack fabrgu";

handle remainder => sub {
    return if $_;
    return "fabrgu is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
