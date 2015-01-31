package DDG::Goodie::IsAwesome::ilumnatr;
# ABSTRACT: ilumnatr's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_ilumnatr";
zci is_cached   => 1;

name "IsAwesome ilumnatr";
description "My first Goodie, it let's the world know that ilumnatr is awesome";
primary_example_queries "duckduckhack ilumnatr";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/ilumnatr.pm";
attribution github => ["https://github.com/ilumnatr", "ilumnatr"],
            twitter => "nwmn";
triggers start => "duckduckhack ilumnatr";

handle remainder => sub {
    return if $_;
    return "ilumnatr is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
