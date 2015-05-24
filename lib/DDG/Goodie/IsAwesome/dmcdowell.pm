#ABSTRACT: dmcdowell's first Goodie

package DDG::Goodie::IsAwesome::dmcdowell;

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_dmcdowell";
zci is_cached   => 1;

name "IsAwesome dmcdowell";
description "My first Goodie, it lets the world know that dmcdowell is awesome";
primary_example_queries "duckduckhack dmcdowell";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/dmcdowell.pm";
attribution github => ["https://github.com/dmcdowell", "dmcdowell"];

triggers any => "duckduckhack dmcdowell";

handle remainder => sub {
    return if $_;
    return "dmcdowell is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
