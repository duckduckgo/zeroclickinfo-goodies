package DDG::Goodie::IsAwesome::samph;
# ABSTRACT: samph's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_samph";
zci is_cached   => 1;

name "IsAwesome samph";
description "My first Goodie, it let's the world know that samph is awesome";
primary_example_queries "duckduckhack samph";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/samph.pm";
attribution github => ["https://github.com/samph", "samph"];

triggers start => "duckduckhack samph";


handle remainder => sub {
    return if $_;
    return "SamPH is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};
1;
