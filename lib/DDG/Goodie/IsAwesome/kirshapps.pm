package DDG::Goodie::IsAwesome::kirshapps;
# ABSTRACT: Kirshapps' first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_kirshapps";
zci is_cached   => 1;

name "IsAwesome kirshapps";
description "Tells everyone that kirshapps is awesome";
primary_example_queries "duckduckhack kirshapps";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/kirshapps.pm";
attribution github => ["https://github.com/kirshapps", "kirshapps"];

triggers start => "duckduckhack kirshapps";

handle remainder => sub {
    return if $_;
    return "kirshapps is awesome and has successfully completed the DuckDuckHack goodie tutorial!"
};

1;
