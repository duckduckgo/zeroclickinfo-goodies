package DDG::Goodie::IsAwesome::redwavestudios;
# ABSTRACT: redwavestudios' first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_redwavestudios";
zci is_cached   => 1;

name "IsAwesome redwavestudios";
description "My first Goodie, it let's the world know that redwavestudios is awesome";
primary_example_queries "duckduckhack redwavestudios";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/redwavestudios.pm";
attribution github => ["https://github.com/redwavestudios", "redwavestudios"],        
            twitter => "redwavestudios";
            
triggers start => "duckduckhack redwavestudios";

handle remainder => sub {
    return if $_;
    return "redwavestudios is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;