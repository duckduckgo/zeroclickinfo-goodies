package DDG::Goodie::IsAwesome::davidgumberg;
# ABSTRACT: davidgumberg's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_davidgumberg";
zci is_cached   => 1;

name "IsAwesome davidgumberg";
description "My first Goodie, it let's the world know that davidgumberg is awesome";
primary_example_queries "duckduckhack davidgumberg";
category "special";
topics "special interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/davidgumberg.pm";
attribution github => ["https://github.com/davidgumberg", "davidgumberg"],
            twitter => "davidgumberg";

triggers start => "duckduckhack davidgumberg";

handle remainder => sub {
    return if $_
    return "davidgumberg is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
