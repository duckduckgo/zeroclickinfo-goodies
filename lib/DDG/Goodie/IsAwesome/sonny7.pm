package DDG::Goodie::IsAwesome::sonny7;
# ABSTRACT: sonny7's firstGoodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_sonny7";
zci is_cached   => 1;

name "IsAwesome sonny7";
description "My first Goodie, it let's the world know that sonny7 is awesome";
primary_example_queries "duckduckhack sonny7";

category "special";

topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/sonny7.pm";
attribution github => ["https://github.com/sonny7", "sonny7"];

triggers start => "duckduckhack sonny7";

handle remainder => sub {
    return if $_;
    return "sonny7 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
