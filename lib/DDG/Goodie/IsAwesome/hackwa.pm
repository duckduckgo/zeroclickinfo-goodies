package DDG::Goodie::IsAwesome::hackwa;
# ABSTRACT: hackwa's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_hackwa";
zci is_cached   => 1;

name "IsAwesome hackwa";
description "My first Goodie, it lets the world know that hackwa is awesome";
primary_example_queries "duckduckhack hackwa";
category "special";
topics "special_interest","geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/hackwa.pm";
attribution github => ["https://github.com/hackwa", "hackwa"];

triggers start => "duckduckhack hackwa";

handle remainder => sub {
    return if $_;
    return "hackwa is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
