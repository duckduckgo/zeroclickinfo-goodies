package DDG::Goodie::IsAwesome::pnodet;
#ABSTRACT: pnodet's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_pnodet";
zci is_cached   => 1;

name "IsAwesome pnodet";
description "My first Goodie, it let's the world know that pnodet is awesome";
primary_example_queries "duckduckhack pnodet";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/pnodet.pm";
attribution github => ["https://github.com/pnodet", "pnodet"],
            twitter => "pnodet";
triggers start => "duckduckhack pnodet";

handle remainder => sub {
    return if $_;
    return "pnodet is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;