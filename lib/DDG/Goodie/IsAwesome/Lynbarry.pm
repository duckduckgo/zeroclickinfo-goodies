package DDG::Goodie::IsAwesome::Lynbarry;
# ABSTRACT: Lynbarry's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_lynbarry";
zci is_cached   => 1;

name "IsAwesome Lynbarry";
description "My first Goodie, it lets the world know that Lynbarry is awesome.";
primary_example_queries "duckduckhack Lynbarry";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/Lynbarry.pm";
attribution github => ["https://github.com/Lynbarry", "Lynbarry"],
            twitter => "quetzco";

triggers start => "duckduckhack lynbarry";

handle remainder => sub {
    return if $_;
    return "Lynbarry is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
