package DDG::Goodie::IsAwesome::CalaveraTheNine;
# ABSTRACT: CalaveraTheNine's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_calavera_the_nine";
zci is_cached   => 1;

name "IsAwesome CalaveraTheNine";
description "My first Goodie, it let's the world know that CalaveraTheNine is awesome";
primary_example_queries "duckduckhack CalaveraTheNine";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/CalaveraTheNine.pm";
attribution github => ["https://github.com/CalaveraTheNine", "CalaveraTheNine"];

triggers start => "duckduckhack calaverathenine";

handle remainder => sub {
    return if $_;
    return "CalaveraTheNine is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
