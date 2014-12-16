package DDG::Goodie::IsAwesome::jimbrighter;
# ABSTRACT: first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_jimbrighter";
zci is_cached   => 1;

name "IsAwesome jim-brighter";
description "First Goodie, tells the world that jim-brighter is awesome";
category "special";
topics "special_interest", "geek";

code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/jim-brighter.pm";
attribution github  => ["https://github.com/jim-brighter", "jim-brighter"],
            twitter => "jim_brighter";

primary_example_queries "duckduckhack jimbrighter";

triggers start => "duckduckhack jimbrighter";

handle remainder => sub {
    return if $_;
    return "jim-brighter is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";

};

1;
