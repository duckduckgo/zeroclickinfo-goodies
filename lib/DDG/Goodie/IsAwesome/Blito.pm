package DDG::Goodie::IsAwesome::Blito;
# ABSTRACT: Blito's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_blito";
zci is_cached   => 1;

name "IsAwesome Blito";
description "My first Goodie, it let's the world know that Blito is awesome";
primary_example_queries "duckduckhack Blito";
secondary_example_queries "optional -- demonstrate any additional triggers";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/Blito.pm";
attribution github => ["https://github.com/Blito", "Blito"];

triggers start => "duckduckhack blito";

handle remainder => sub {
    return if $_;
    return "Blito is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
