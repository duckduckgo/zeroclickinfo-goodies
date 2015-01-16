package DDG::Goodie::IsAwesome::omareduardo;
# ABSTRACT: omareduardo's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_omareduardo";
zci is_cached   => 1;

name "IsAwesome omareduardo";
description "My first Goodie, it let's the world know that omareduardo is awesome";
primary_example_queries "duckduckhack omareduardo";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/omareduardo.pm";
attribution github => ["https://github.com/omareduardo/", "omareduardo"],
            twitter => "omareduardo";

triggers start => "duckduckhack omareduardo";

handle remainder => sub {
    return if $_;
    return "omareduardo is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
