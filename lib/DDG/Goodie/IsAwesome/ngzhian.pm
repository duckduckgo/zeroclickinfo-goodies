package DDG::Goodie::IsAwesome::ngzhian;
# ABSTRACT: ngzhian's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_ngzhian";
zci is_cached   => 1;

name "IsAwesome ngzhian";
description "My first Goodie, it lets the world know that ngzhian is awesome";
primary_example_queries "duckduckhack ngzhian";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/ngzhian.pm";
attribution github => ["https://github.com/ngzhian", "ngzhian"],
            twitter => "ngzhian";

triggers start => "duckduckhack ngzhian";

handle remainder => sub {
    return if $_;
    return "ngzhian is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
