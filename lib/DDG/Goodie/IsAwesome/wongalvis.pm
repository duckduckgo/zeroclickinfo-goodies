package DDG::Goodie::IsAwesome::wongalvis;
# ABSTRACT: wongalvis' first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_wongalvis";
zci is_cached   => 1;

name "IsAwesome wongalvis";
description "My first Goodie, it lets the world know that wongalvis is awesome";
primary_example_queries "duckduckhack wongalvis";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/wongalvis.pm";
attribution github => ["https://github.com/wongalvis", "wongalvis"];

triggers start => "duckduckhack wongalvis";

handle remainder => sub {
    return if $_;
    return "wongalvis is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
