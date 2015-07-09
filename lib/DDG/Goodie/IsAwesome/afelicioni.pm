package DDG::Goodie::IsAwesome::afelicioni;
# ABSTRACT: afelicioni's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_afelicioni";
zci is_cached   => 1;

name "IsAwesome afelicioni";
description "My first Goodie, it lets the world know that afelicioni is awesome";
primary_example_queries "duckduckhack afelicioni";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/afelicioni.pm";
attribution github => ["https://github.com/afelicioni", "afelicioni"],
            twitter => "afelicioni_pro";

triggers start => "duckduckhack afelicioni";

handle remainder => sub {
    return if $_;
    return "afelicioni is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
