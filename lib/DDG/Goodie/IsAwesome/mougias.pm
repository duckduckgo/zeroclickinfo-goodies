package DDG::Goodie::IsAwesome::mougias;
# ABSTRACT: mougias's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_mougias";
zci is_cached   => 1;

name "IsAwesome mougias";
description "My first Goodie, it let's the world know that mougias is awesome";
primary_example_queries "duckduckhack mougias";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/mougias.pm";
attribution github => ["https://github.com/mougias", "mougias"],
            twitter => "gcmougias";

triggers start => "duckduckhack mougias";

handle remainder => sub {
    return if $_;
    return "mougias is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
