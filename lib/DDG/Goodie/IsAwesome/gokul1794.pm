package DDG::Goodie::IsAwesome::gokul1794;
# ABSTRACT: gokul1794's first goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_gokul1794";
zci is_cached   => 1;

name "IsAwesome gokul1794";
description "Not my first goodie, but let the world know that gokul1794 is awesome";
primary_example_queries "duckduckhack gokul1794";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/gokul1794.pm";
attribution github => ["https://github.com/gokul1794", "gokul1794"],
            twitter => "gokul_shanth";

triggers start => "duckduckhack gokul1794";

handle remainder => sub {
    return if $_;
    return "gokul1794 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
