package DDG::Goodie::IsAwesome::domjacko;
# ABSTRACT: domjacko's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_domjacko";
zci is_cached   => 1;

name "IsAwesome domjacko";
description "My first Goodie, it lets the world know that domjacko is awesome";
primary_example_queries "duckduckhack domjacko";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/domjacko.pm";
attribution github => ["https://github.com/domjacko", "domjacko"],
            twitter => "domjacko";

triggers start => "duckduckhack domjacko";

handle remainder => sub {
    return if $_;
    return "domjacko is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
